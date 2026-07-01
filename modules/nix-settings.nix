# Nix 自身配置（GC、substituters、flakes 等）
{ ... }:

{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
      # 性能优化
      max-jobs = "auto";
      min-free = 5 * 1024 * 1024 * 1024;  # 5GB
      max-free = 20 * 1024 * 1024 * 1024;  # 20GB
      build-cores = 0;  # 使用所有可用核心
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
  };
}
