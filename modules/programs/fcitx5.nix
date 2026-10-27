# Fcitx5 引擎与前端；自定义码表由 home/fcitx5-profile.nix 链接 dotfile/fcitx5。
{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # 默认使用 X11 前端；Mango 模块单独启用 Wayland 前端。
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-pinyin-zhwiki
      ];
    };
  };
}
