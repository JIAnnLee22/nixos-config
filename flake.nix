{
  description = "NixOS flake for jiannlee22";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # master = unstable line; matches nixos-unstable (avoids github: API on flake update).
    home-manager = {
      url = "git+https://github.com/nix-community/home-manager.git?shallow=1&ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "git+https://github.com/mangowm/mango.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    daeuniverse = {
      url = "git+https://github.com/daeuniverse/flake.nix.git?shallow=1&ref=main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    mango,
    daeuniverse,
    noctalia,
    ...
  }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    # Standalone: `home-manager switch --flake ~/nixos-config#jiannlee22`
    # (`-c` is --specialisation, not a config path.)
    homeConfigurations.jiannlee22 = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home/jiannlee22.nix
        {
          home.packages = [
            home-manager.packages.${system}.home-manager
          ];
        }
      ];
    };

    nixosConfigurations.ser = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit home-manager; };
      modules = [
        ./host/ser
        mango.nixosModules.mango
        home-manager.nixosModules.default
        ./nixos/home-manager.nix
        ./nixos/desktop/common.nix
        ./nixos/software.nix
        daeuniverse.nixosModules.daed
        noctalia.nixosModules.default
        ./nixos/services.nix
        ./nixos/users.nix
      ];
    };
  };
}
