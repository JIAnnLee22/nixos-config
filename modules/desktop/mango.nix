# Mango WM 桌面环境配置
{ config, pkgs, ... }:

let
  user = config.users.users.jiannlee22;
  flakeDir = "${user.home}/nixos-config";
  nixos-rebuild-latest-mango = pkgs.writeShellApplication {
    name = "nixos-rebuild-latest-mango";
    runtimeInputs = with pkgs; [
      nix
      git
    ];
    text = ''
      set -euo pipefail
      flake_dir="''${NIXOS_CONFIG_FLAKE:-${flakeDir}}"
      nix flake update mango --flake "$flake_dir"
      exec sudo nixos-rebuild "$@" --flake "$flake_dir"
    '';
  };
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
  # swaylock PAM is only auto-configured with programs.sway; Mango uses swaylock directly.
  security.pam.services.swaylock = {};

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
      nixos-rebuild-latest-mango
      mango-screenshot
    ];
}
