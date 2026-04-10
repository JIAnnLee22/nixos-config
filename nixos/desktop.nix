{ config, lib, pkgs, ... }:

let
  session = config.custom.desktopSession;
in
{
  options.custom.desktopSession = lib.mkOption {
    type = lib.types.enum [ "kde" "mango" ];
    default = "kde";
    description = "Choose one desktop session profile.";
  };

  config = {
    i18n.defaultLocale = "zh_CN.UTF-8";
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        qt6Packages.fcitx5-chinese-addons
        fcitx5-gtk
        fcitx5-pinyin-zhwiki
      ];
    };

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    services.desktopManager.plasma6.enable = (session == "kde");
    programs.mango.enable = (session == "mango");
  };
}
