# 桌面环境通用配置（输入法、语言等）
{ pkgs, ... }:

{
  imports = [ ../programs/fcitx5.nix ];

  i18n.defaultLocale = "zh_CN.UTF-8";
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
