{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
    ../../modules/nvidia.nix
    ../../modules/game
  ];

  networking.hostName = "dnwx";

  boot.kernelPackages = pkgs.linuxPackages_zen;

  # Hibernate 休眠唤醒设备（swap 分区 UUID）
  # 设置后 NixOS 会自动向内核启动参数添加 resume=/dev/disk/by-uuid/... 并配置 initrd 镜像恢复
  boot.resumeDevice = "/dev/disk/by-uuid/416d1bcb-d787-44a3-8ae8-5bfe22200be1";

  # Btrfs 挂载优化
  fileSystems."/".options = [
    "compress=zstd"
    "noatime"
  ];
  fileSystems."/home".options = [
    "compress=zstd"
    "noatime"
  ];
  fileSystems."/nix".options = [
    "compress=zstd"
    "noatime"
  ];

  # SSD 定期 TRIM
  services.fstrim.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  system.stateVersion = "25.11";
}
