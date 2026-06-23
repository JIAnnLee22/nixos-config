# 指针光标配置
{ pkgs, ... }:

{
  home.pointerCursor = {
    package = pkgs.oreo-cursors-plus;
    name = "oreo_white_cursors";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };
}
