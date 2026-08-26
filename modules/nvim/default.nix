{ config, pkgs, ... }:
let
  dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
in
{
  home.packages = with pkgs; [ neovim ];
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfile}/nvim/";
}
