{ pkgs, ... }:

{
  programs.mango.enable = true;

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  services.displayManager.defaultSession = "mango";

  environment.systemPackages = with pkgs; [
    fuzzel
    cliphist
    wl-clipboard
    wl-clip-persist
  ];

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
