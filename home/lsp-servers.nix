{ inputs, pkgs, ... }:
let
  kotlin_lsp = inputs.kotlin_lsp.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = with pkgs; [
    # LSP servers (Neovim config is managed outside Home Manager)
    clang-tools
    lua-language-server
    # kotlin_lsp.flake exports the JetBrains server package (intellij-server).
    kotlin_lsp
    # Keep the older server available as an explicit fallback.
    kotlin-language-server
    jdt-language-server
    groovy-language-server
    lemminx
    nil
    rust-analyzer
  ];
}
