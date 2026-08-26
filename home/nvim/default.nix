{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
    colorscheme = "catppuccin";
    colorschemes.catppuccin.enable = true;
    opts.clipboard = "unnamedplus";
    opts.number = true;
    opts.relativenumber = true;
    opts.ts = 2;
    opts.sw = 2;
    opts.swapfile = false;
    opts.completeopt = [
      "menuone"
      "noselect"
      "popup"
    ];
    clipboard.providers = {
      wl-copy.enable = true;
      xsel.enable = true;
    };

    plugins.clangd-extensions = {
      enable = true;
      enableOffsetEncodingWorkaround = true;
    };

    plugins.lsp = {
      enable = true;
      onAttach = ''
        if client:supports_method("textDocument/completion") then
          vim.lsp.completion.enable(true, client.id, bufnr, {
            autotrigger = true,
          })
        end
      '';

      keymaps = {
        silent = true;
        lspBuf = {
          gd = "definition";
          gD = "declaration";
          gi = "implementation";
          gr = "references";
          K = "hover";
        };
        diagnostic = {
          "[d" = "goto_prev";
          "]d" = "goto_next";
        };
        extra = [
          {
            mode = "n";
            key = "<leader>ch";
            action = "<cmd>ClangdSwitchSourceHeader<CR>";
            options.desc = "C/C++ switch source/header";
          }
        ];
      };

      servers = {
        nixd = {
          enable = true;
          filetypes = [ "nix" ];
          rootMarkers = [
            "flake.nix"
            "shell.nix"
            "default.nix"
          ];
          settings = {
            formatting.command = [
              "${pkgs.nixfmt}/bin/nixfmt"
            ];
          };

        };
        clangd = {
          enable = true;

          package = pkgs.clang-tools;

          filetypes = [
            "c"
            "cpp"
            "objc"
            "objcpp"
            "cuda"
          ];

          rootMarkers = [
            "compile_commands.json"
            "compile_flags.txt"
            ".clangd"
            "CMakeLists.txt"
            "Makefile"
            "meson.build"
            ".git"
          ];

          # 让没有 compile_commands.json 的简单 C 项目也能解析本地头文件。
          # 更复杂项目仍建议用 cmake/bear 生成 compile_commands.json。
          extraOptions.init_options.fallbackFlags = [
            "-std=c17"
            "-I."
            "-Iinclude"
            "-Isrc"
          ];

          cmd = [
            "${pkgs.clang-tools}/bin/clangd"
            "--background-index"
            "--clang-tidy"
            "--completion-style=detailed"
            "--header-insertion=iwyu"
          ];
        };
        gopls = {
          enable = true;
          package = pkgs.gopls;

          filetypes = [
            "go"
            "gomod"
            "gowork"
            "gotmpl"
          ];

          rootMarkers = [
            "go.work"
            "go.mod"
            ".git"
          ];

          settings.gopls = {
            gofumpt = true;
            staticcheck = true;
            usePlaceholders = true;
            completeUnimported = true;
            analyses = {
              shadow = true;
              unusedparams = true;
              unusedwrite = true;
            };
          };
        };
        vtsls = {
          enable = true;

          # 允许项目本地 node_modules 中的 TypeScript 覆盖 nix 包内版本。
          packageFallback = true;

          filetypes = [
            "javascript"
            "javascriptreact"
            "javascript.jsx"
            "typescript"
            "typescriptreact"
            "typescript.tsx"
          ];

          rootMarkers = [
            "package.json"
            "tsconfig.json"
            "jsconfig.json"
            ".git"
          ];

          # vtsls 包装 VS Code 的 TypeScript 扩展，settings 遵循 VS Code 风格。
          settings = {
            vtsls.autoUseWorkspaceTsdk = true;

            typescript = {
              suggest.completeFunctionCalls = true;
              inlayHints = {
                parameterNames.enabled = "all";
                parameterTypes.enabled = true;
                variableTypes.enabled = true;
                propertyDeclarationTypes.enabled = true;
                functionLikeReturnTypes.enabled = true;
              };
            };

            javascript = {
              suggest.completeFunctionCalls = true;
            };
          };
        };
        rust_analyzer = {
          enable = true;
          package = pkgs.rust-analyzer;
          installCargo = true;
          installRustc = true;

          filetypes = [ "rust" ];

          rootMarkers = [
            "Cargo.toml"
            "rust-project.json"
            ".git"
          ];

          settings."rust-analyzer" = {
            cargo.allFeatures = true;
            check.command = "clippy";
            rustfmt.overrideCommand = [
              "${pkgs.rustfmt}/bin/rustfmt"
            ];
          };
        };
      };
    };
    plugins.lsp-format = {
      enable = true;
    };
  };
}
