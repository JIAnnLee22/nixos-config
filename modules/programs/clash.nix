{ ... }:
{
  # Clash Verge's Linux sysproxy backend stores non-KDE proxy settings in
  # dconf. Enabling the NixOS module also installs its D-Bus/user service;
  # adding the dconf package alone is not enough to persist gsettings writes.
  programs.dconf.enable = true;

  programs.clash-verge = {
    enable = true;
    serviceMode = true;
    autoStart = true;
    tunMode = true;
    group = "wheel";
  };
}
