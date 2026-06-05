{ config, pkgs, ... }:

let
  wallpaperFile = "a_flower_on_a_dark_background.png";
  wallpaperDir = "${config.home.homeDirectory}/.local/share/wallpapers";
in
{
  home.packages = [ pkgs.swaybg ];

  home.file.".local/share/wallpapers/${wallpaperFile}".source =
    ../../a_flower_on_a_dark_background.png;

  _module.args.mangoWallpaperPath = "${wallpaperDir}/${wallpaperFile}";
}
