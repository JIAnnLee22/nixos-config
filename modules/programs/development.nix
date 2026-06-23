# 开发工具
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    gcc
    nodejs_24
    neovim
  ];
}
