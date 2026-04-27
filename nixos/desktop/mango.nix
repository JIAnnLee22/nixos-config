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
    ++ [
      mango-screenshot
      config.services.noctalia-shell.package
    ];

  services.noctalia-shell.enable = false;
}
