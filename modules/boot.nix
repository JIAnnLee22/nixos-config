# Boot loader 配置
{ ... }:

{
  boot.loader = {
    systemd-boot = {
      enable = true;
      configurationLimit = 1;
    };
    efi.canTouchEfiVariables = true;
  };
}
