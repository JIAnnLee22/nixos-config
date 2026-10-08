# NVIDIA 官方专有驱动配置
{ config, pkgs, ... }:

{
  # 启用图形硬件加速及 32 位支持
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  # 加载 NVIDIA 专有驱动
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # 启用内核模式设置（Modesetting，Wayland 必须）
    modesetting.enable = true;

    # 电源管理（台式机单卡禁用，避免睡眠/唤醒异常）
    powerManagement.enable = false;
    powerManagement.finegrained = false;

    # 使用闭源专有驱动（GTX 1650 SUPER 为 Turing 架构 TU116，闭源模块稳定性更佳）
    open = false;

    # 启用 nvidia-settings 控制面板
    nvidiaSettings = true;

    # 选择驱动版本（稳定版）
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Wayland 与硬件视频解码环境变量
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
}
