{ pkgs, ... }:

{
  imports = [ ../fcitx5-bundle.nix ];

  i18n.defaultLocale = "zh_CN.UTF-8";
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # Hyprland / Wayland：避免 GTK_IM_MODULE 等告警，并与官方 Wayland 说明一致。
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-pinyin-zhwiki
      ];
    };
  };
}
