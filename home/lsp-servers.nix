{ pkgs, ... }:
let
  kotlin-lsp-jetbrains = pkgs.callPackage ./kotlin-lsp.nix { };
in
{
  home.packages = with pkgs; [
    # LSP servers (Neovim config is managed outside Home Manager)
    jdt-language-server
    jdk17
    kotlin-lsp-jetbrains
    kotlin-language-server
    clang-tools
    lua-language-server
    nil
  ];
}
