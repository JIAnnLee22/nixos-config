{ config, lib, pkgs, inputs, ... }:
let
dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
in
{
  # mangobar 配置引用的交互命令：pamixer（音量）、wlogout（电源菜单）、brightnessctl（背光）
  home.packages = [
    inputs.mangobar.packages.${pkgs.system}.default
    pkgs.pamixer
    pkgs.wlogout
    pkgs.brightnessctl
  ];
  xdg.configFile."mangobar".source = config.lib.file.mkOutOfStoreSymlink "${dotfile}/mangobar/";
}
