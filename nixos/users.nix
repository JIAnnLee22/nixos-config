{ ... }:

{
  # Vial/QMK 键盘配置工具需要的组
  users.groups.plugdev = {};

  users.users.jiannlee22 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "adbusers" "uinput" "plugdev" ];
  };
}
