-- Run from the repository root:
-- KOTLIN_LSP_CMD=/nix/store/.../bin/kotlin-lsp nvim --headless -u NONE -l tests/kotlin-lsp-smoke.lua
-- Optional: KOTLIN_LSP_FILE=/absolute/path/to/project/Main.kt (imports that project).
-- KOTLIN_LSP_HOVER=LINE:COLUMN additionally requires a nonempty hover (1-based, UTF-16 column).
local fixture
local client
local function test()
  vim.opt.runtimepath:prepend(vim.fn.getcwd() .. '/dotfile/nvim')
  vim.cmd('filetype on')
  local config = vim.lsp.config.kotlin_lsp
  assert(config and config.cmd[1] == 'kotlin-lsp', 'must use official kotlin-lsp CLI')
  assert(vim.fn.filereadable('dotfile/nvim/lsp/kotlin_language_server.lua') == 0,
    'legacy server config must not be present')
  local executable = vim.env.KOTLIN_LSP_CMD or config.cmd[1]
  assert(vim.fn.executable(executable) == 1, 'missing executable: ' .. executable)
  local import_error
  vim.lsp.config('kotlin_lsp', {
    cmd = { executable, '--stdio' },
    handlers = {
      ['window/logMessage'] = function(err, result, ctx, handler_config)
        if result and result.type == 1 and result.message:find('Error importing project', 1, true) then
          import_error = result.message
        end
        return vim.lsp.handlers['window/logMessage'](err, result, ctx, handler_config)
      end,
    },
  })
  local file = vim.env.KOTLIN_LSP_FILE
  if not file then
    fixture = vim.fn.tempname()
    vim.fn.mkdir(fixture .. '/app/src/main/kotlin', 'p')
    vim.fn.writefile({ 'rootProject.name = "kotlin-lsp-smoke"' }, fixture .. '/settings.gradle.kts')
    vim.fn.writefile({}, fixture .. '/app/build.gradle.kts')
    file = fixture .. '/app/src/main/kotlin/Main.kt'
    vim.fn.writefile({ 'fun main() { println("hello") }' }, file)
  end
  vim.lsp.enable('kotlin_lsp')
  vim.cmd.edit(vim.fn.fnameescape(file))
  local bufnr = vim.api.nvim_get_current_buf()
  assert(vim.bo[bufnr].filetype == 'kotlin', 'Kotlin filetype detection failed')
  assert(vim.wait(90000, function()
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr, name = 'kotlin_lsp' })) do
      if c.initialized and not c:is_stopped() then client = c; return true end
    end
    return false
  end, 100), 'LSP did not initialize/attach; inspect ' .. vim.lsp.log.get_filename())
  if fixture then
    assert(client.config.root_dir == fixture, 'must use Gradle settings root, not app module')
  end
  for _, method in ipairs({ 'textDocument/hover', 'textDocument/definition', 'textDocument/completion' }) do
    assert(client:supports_method(method), 'missing capability: ' .. method)
  end
  -- Catch servers which advertise capabilities and then immediately crash.
  assert(not vim.wait(10000, function() return client:is_stopped() end, 100),
    'server exited shortly after initialization')
  print('PASS: official Kotlin LSP initialized/attached and stayed alive; hover, definition, completion advertised; root=' .. client.config.root_dir)
  if vim.env.KOTLIN_LSP_HOVER then
    local line, column = vim.env.KOTLIN_LSP_HOVER:match('^(%d+):(%d+)$')
    assert(line and column and tonumber(line) > 0 and tonumber(column) > 0, 'invalid hover position')
    local params = {
      textDocument = { uri = vim.uri_from_bufnr(bufnr) },
      position = { line = tonumber(line) - 1, character = tonumber(column) - 1 },
    }
    local deadline = vim.uv.hrtime() + 180 * 1e9
    local hover
    repeat
      assert(not import_error, import_error)
      local response = client:request_sync('textDocument/hover', params, 10000, bufnr)
      if response and not response.err and response.result then
        local contents = response.result.contents
        if contents and #vim.lsp.util.convert_input_to_markdown_lines(contents) > 0 then
          hover = contents
        end
      end
      if not hover then vim.wait(1000, function() return client:is_stopped() end, 100) end
    until hover or client:is_stopped() or vim.uv.hrtime() >= deadline
    assert(not import_error, import_error)
    assert(hover, 'no semantic hover within 180s; inspect Gradle import/server logs')
    print('PASS: semantic hover: ' .. vim.inspect(hover))
  else
    print('NOTE: this smoke test does not assert Android Gradle sync or semantic results.')
  end
end
local ok, err = xpcall(test, debug.traceback)
for _, c in ipairs(vim.lsp.get_clients()) do c:stop() end
vim.wait(5000, function() return #vim.lsp.get_clients() == 0 end, 100)
for _, c in ipairs(vim.lsp.get_clients()) do c:stop(true) end
if fixture then vim.fn.delete(fixture, 'rf') end
if not ok then io.stderr:write(err .. '\n'); vim.cmd('cquit 1') end
vim.cmd('qa!')
