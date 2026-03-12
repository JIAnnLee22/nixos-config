{
  description = "NixOS flake for jiannlee22";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # 使用自己的 st 仓库 flake
    st.url = "github:JIAnnLee22/st";
    st.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, st, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.ser = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        ./host/ser
      ];
      # 把 st 这一 flake 作为 specialArgs 传给 NixOS 配置
      specialArgs = {
        inherit st;
      };
    };
  };
}
