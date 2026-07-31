{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  networking.hostName = "ser";
  # The shared cache settings also cover Home Manager's user-level nix.conf.
  chaotic.nyx.cache.enable = false;

  boot.kernelPackages = pkgs.linuxPackages_cachyos;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "25.11";
}
