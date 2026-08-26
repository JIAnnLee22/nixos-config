# Home Manager NixOS 模块配置
{ home-manager, inputs, ... }:

{
  # https://nix-community.github.io/home-manager/index.xhtml#sec-install-nixos-module
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.jiannlee22 = { pkgs, ... }: {
      imports = [ ../home/jiannlee22.nix ];
      home.packages = [
        home-manager.packages.${pkgs.stdenv.hostPlatform.system}.home-manager
      ];
    };
  };
}
