{
  description = "NixOS flake for jiannlee22";
  inputs = {
    # `github:` uses api.github.com and hits anonymous rate limits on shared IPs (VPN/daed).
    nixpkgs.url = "git+https://github.com/NixOS/nixpkgs.git?shallow=1&ref=nixos-unstable";
    # master = unstable line; matches nixos-unstable (avoids github: API on flake update).
    home-manager = {
      url = "git+https://github.com/nix-community/home-manager.git?shallow=1&ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mango = {
      url = "git+https://github.com/mangowm/mango.git?shallow=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    mango,
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
      specialArgs = { inherit inputs home-manager; };
      modules = [
        # Overlays
        { nixpkgs.overlays = import ./modules/overlays; }
        
        # 主机配置（包括硬件和主机特定网络）
        ./host/ser
        mango.nixosModules.mango
        
        # nixpkgs 全局配置
        ./modules/nixpkgs.nix
        
        # Nix 设置
        ./modules/nix-settings.nix
        
        # 系统基础
        ./modules/boot.nix
        ./modules/locale.nix
        ./modules/networking.nix
        ./modules/hardware.nix
        
        # 字体
        ./modules/fonts.nix
        
        # 安全
        ./modules/security.nix
        
        # 程序
        ./modules/programs/java.nix
        ./modules/programs/cli.nix
        ./modules/programs/development.nix
        ./modules/programs/gui.nix
        ./modules/programs/st.nix
        
        # 硬件服务
        ./modules/audio.nix
        ./modules/bluetooth.nix
        
        # 程序 - Android
        ./modules/programs/android.nix
        ./modules/programs/fcitx5.nix
        
        # 桌面环境
        ./modules/desktop/common.nix
        ./modules/desktop/mango.nix
        
        # 系统服务
        ./modules/services/envfs.nix
        ./modules/services/ssh.nix
        ./modules/services/daed.nix
        
        # Home Manager
        home-manager.nixosModules.default
        ./modules/home-manager.nix
        
        # 用户
        ./modules/users.nix
      ];
    };
  };
}
