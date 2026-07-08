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
      };
    };
    plugins.lsp-format = {
      enable = true;
    };
  };
}
