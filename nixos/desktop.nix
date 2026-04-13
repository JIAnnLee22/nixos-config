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

    services.displayManager.enable = (session == "mango");
    services.displayManager.sddm.enable = (session == "kde");
    services.displayManager.sddm.wayland.enable = (session == "kde");

    services.desktopManager.plasma6.enable = (session == "kde");
    programs.mango.enable = (session == "mango");

    programs.dms-shell = lib.mkIf (session == "mango") {
      enable = true;
      systemd = {
        enable = true;
        target = "wayland-session.target";
        restartIfChanged = true;
      };
      # Keep explicit defaults for readability and future tuning.
      enableSystemMonitoring = true;
      enableVPN = true;
      enableDynamicTheming = true;
      enableAudioWavelength = true;
      enableCalendarEvents = true;
      enableClipboardPaste = true;
    };
  };
}
