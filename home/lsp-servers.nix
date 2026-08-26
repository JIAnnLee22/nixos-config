{ pkgs, ... }:
let
in
{
  home.packages = with pkgs; [
    # LSP servers (Neovim config is managed outside Home Manager)
    clang-tools
    lua-language-server
    kotlin-language-server
    jdt-language-server
    groovy-language-server
    lemminx
    nil
    rust-analyzer
  ];
}
