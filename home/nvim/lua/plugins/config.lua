local M = {}

M.servers = {
  clangd = {
    cmd = { "clangd", "--query-driver=/nix/store/**" },
    root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
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
  rust_analyzer = {
    cmd = { "rust-analyzer" },
    root_markers = { "Cargo.toml", "rust-project.json", ".git" },
    settings = {
      ["rust-analyzer"] = {
        check = {
          command = "clippy",
        },
        diagnostics = {
          enable = true,
        },
        cargo = {
          allFeatures = true,
        },
      },
    },
  },
}

return M
