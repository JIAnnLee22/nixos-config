{ ... }:

{
  # https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.jiannlee22 = import ../home/jiannlee22.nix;
  };
}
