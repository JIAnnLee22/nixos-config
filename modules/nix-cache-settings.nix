{
  substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirror.nju.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];

  # Avoid waiting several minutes on a dead mirror before trying another one.
  connect-timeout = 5;
  stalled-download-timeout = 30;

  # Last resort: build locally if every binary cache fails.
  fallback = true;

  # The Chinese mirrors above synchronize the official cache and reuse its key.
  trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
}
