{ config, pkgs, ... }:

let
  mango-screenshot = pkgs.writeShellApplication {
    name = "mango-screenshot";
    runtimeInputs = with pkgs; [
      grim
      satty
      wl-clipboard
      config.programs.mango.package
    ];
    text = builtins.readFile ../../home/mango/screenshot.sh;
  };
in
{
  programs.mango.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.displayManager.defaultSession = "mango";

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
  };

  environment.systemPackages =
    (with pkgs; [
      fuzzel
      cliphist
      wl-clipboard
      wl-clip-persist
      xdg-desktop-portal-wlr
    ])
    ++ [ mango-screenshot ];

  programs.dms-shell = {
    enable = true;
    systemd = {
      enable = true;
      target = "wayland-session.target";
      restartIfChanged = true;
    };
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = true;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;
  };
}
