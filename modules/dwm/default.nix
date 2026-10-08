# dwm 的用户配置，仅在 NixOS 引用 desktop/dwm.nix 时加载。
{ config, pkgs, ... }:

let
  dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
  # 原脚本使用 /bin/bash；NixOS 只有 /bin/sh，借助 store 中的 Bash 执行。
  autostart = pkgs.writeShellScript "dwm-autostart" ''
    source "${dotfile}/dwm/autostart.sh"
  '';
in
{
  xdg.configFile."dwm/autostart.sh".source = autostart;
  xdg.configFile."dwm/scripts".source = config.lib.file.mkOutOfStoreSymlink "${dotfile}/dwm/scripts";

  services.dunst.enable = true;
}
