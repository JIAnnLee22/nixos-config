{
  description = "NixOS flake for jiannlee22";
  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
    home-manager = {
      url = "git+https://github.com/nix-community/home-manager.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "git+https://github.com/mangowm/mango.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, mango, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.ser = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./host/ser
        mango.nixosModules.mango
        home-manager.nixosModules.home-manager
        ./nixos/desktop.nix
        ./nixos/software.nix
        ./nixos/services.nix
        ./nixos/users.nix
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.jiannlee22 = import ./home/jiannlee22.nix;
          };
        }
      ];
    };
  };
}
