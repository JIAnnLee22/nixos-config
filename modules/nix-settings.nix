# Nix 自身配置（GC、substituters、flakes 等）
{ ... }:
let
  cacheSettings = import ./nix-cache-settings.nix;
in
{
  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
      # 性能优化
      max-jobs = "auto";
      min-free = 5 * 1024 * 1024 * 1024; # 5GB
      max-free = 20 * 1024 * 1024 * 1024; # 20GB
      build-cores = 0; # 使用所有可用核心
    }
    // cacheSettings;
  };
}
