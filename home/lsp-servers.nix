{ pkgs, ... }:
let
in
{
  home.packages = with pkgs; [
    # LSP servers (Neovim config is managed outside Home Manager)
    jdt-language-server
    jdk17
    kotlin-language-server
    clang-tools
    lua-language-server
    nil
  ];
}
