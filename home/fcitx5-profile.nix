# ~/.config/fcitx5/profile 会覆盖 NixOS 的 /etc/xdg/fcitx5/profile，因此把分组写在这里。
{ pkgs, ... }:
let
  ini = pkgs.formats.ini { };
in
{
  xdg.configFile."fcitx5/profile".source = ini.generate "fcitx5-profile" {
    "Groups/0" = {
      Name = "Default";
      "Default Layout" = "us";
      DefaultIM = "flypy";
    };
    "Groups/0/Items/0" = {
      Name = "keyboard-us";
      Layout = "";
    };
    "Groups/0/Items/1" = {
      Name = "flypy";
      Layout = "";
    };
    "Groups/0/Items/2" = {
      Name = "tigress";
      Layout = "";
    };
    GroupOrder."0" = "Default";
  };
}
