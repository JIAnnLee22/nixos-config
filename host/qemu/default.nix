{ ... }:

{
  imports = [
    ./configuration.nix
  ];

  networking.hostName = "qemu";

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "25.11";
}
