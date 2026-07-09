{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    nixpkgs.useGlobalPackages = true;
    colorscheme = "catppuccin";
    colorschemes.catppuccin.enable = true;
    opts.clipboard = "unnamedplus";
    clipboard.providers = {
      wl-copy.enable = true;
      xsel.enable = true;
    };
    plugins.lsp = {
      enable = true;

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
            ".git"
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
