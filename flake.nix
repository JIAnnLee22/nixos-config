{
  description = "NixOS flake for jiannlee22";
  inputs = {
    nixpkgs.url = "git+https://mirrors.nju.edu.cn/git/nixpkgs.git?ref=nixos-unstable&shallow=1";
  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.ser = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./host/ser
        ./nixos/desktop.nix
        ./nixos/software.nix
        ./nixos/services.nix
        ./nixos/users.nix
      ];
    };
  };
}
