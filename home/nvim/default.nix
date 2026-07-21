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
    clipboard.providers = {
      wl-copy.enable = true;
      xsel.enable = true;
    };
    plugins.friendly-snippets.enable = true;
    plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;
      settings = {
        keymap = {
          preset = "default";
          "<C-space>" = false;
        };
        sources.default = [
          "lsp"
          "path"
          "snippets"
          "buffer"
        ];
        completion.documentation.auto_show = true;
        signature.enabled = true;
      };
    };

    plugins.clangd-extensions = {
      enable = true;
      enableOffsetEncodingWorkaround = true;
    };

    plugins.lsp = {
      enable = true;

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
