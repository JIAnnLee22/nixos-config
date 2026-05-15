{ home-manager, ... }:

{
  # https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    # Same revision as the NixOS module; puts `home-manager` on PATH for standalone use.
    users.jiannlee22 = { pkgs, ... }: {
      imports = [ ../home/jiannlee22.nix ];
      home.packages = [
        home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
      ];
    };
  };
}
