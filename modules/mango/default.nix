{ config, lib, ... }:
let
  dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
in
{
  xdg.configFile."mango".source = config.lib.file.mkOutOfStoreSymlink "${dotfile}/mango/";
}
