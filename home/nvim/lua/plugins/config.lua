local M = {}

---@return string cmd kotlin LSP 可执行文件名
function M.kotlin_cmd()
  return "kotlin-language-server"
end

---@return boolean 是否使用 JetBrains kotlin-lsp
function M.use_kotlin_lsp()
  return M.kotlin_cmd() == "kotlin-lsp"
end

---@return string kotlin LSP 配置名
function M.kotlin_server()
  return M.use_kotlin_lsp() and "kotlin_lsp" or "kotlin_language_server"
end

M.servers = {
  clangd = {
    cmd = { "clangd", "--query-driver=/nix/store/**" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
  },
  jdtls = {
    cmd = { "jdtls" },
    root_markers = {
      "build.gradle",
      "build.gradle.kts",
      "pom.xml",
      "settings.gradle",
      "settings.gradle.kts",
      ".git",
    },
    settings = {
      java = {
        eclipse = {
          downloadSources = true,
        },
        configuration = {
          updateBuildConfiguration = "automatic",
        },
        format = {
          enabled = false,
        },
      },
    },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
        },
      },
    },
  },
  nil_ls = {
    cmd = { "nil" },
    root_markers = { "flake.nix", ".git" },
    settings = {
      ["nil"] = {
        nix = {
          flake = {
            autoArchive = true,
          },
        },
      },
    },
  },
}

M.kotlin_overrides = {
  kotlin_language_server = {
    cmd = { "kotlin-language-server" },
    root_markers = {
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts",
      "pom.xml",
      ".git",
    },
  },
}

return M
