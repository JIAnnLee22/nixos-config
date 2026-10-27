# 桌面环境通用配置（输入法、语言等）
{ ... }:

{
  imports = [ ../programs/fcitx5.nix ];

  i18n.defaultLocale = "zh_CN.UTF-8";
}
