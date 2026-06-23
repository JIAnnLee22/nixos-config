# 安全相关配置（sudo、PAM、udev 等）
{ ... }:

{
  # 图形化 sudo 密码输入支持
  security.sudo.extraConfig = ''
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XAUTHORITY"
    Defaults env_keep += "SUDO_ASKPASS"
  '';

  # Vial/QMK 键盘固件配置工具
  # 需要 udev 规则允许普通用户访问 HID 设备
  services.udev.extraRules = ''
    # Vial/QMK 设备 - 允许 plugdev 组访问
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    KERNEL=="hidraw*", SUBSYSTEM=="usb", MODE="0660", GROUP="plugdev", TAG+="uaccess"
    # SZR35 键盘 (VID:3601 PID:45D4)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="3601", ATTRS{idProduct}=="45d4", MODE="0660", GROUP="plugdev"
  '';
}
