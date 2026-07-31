{ ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.limine.enable = true;

  services.btrfs.autoScrub.enable = true;
  services.btrfs.autoScrub.interval = "weekly";

}
