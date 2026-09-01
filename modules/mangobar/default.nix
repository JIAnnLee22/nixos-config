{ config, lib, pkgs, inputs, ... }:
let
dotfile = "${config.home.homeDirectory}/nixos-config/dotfile";
in
{
  home.packages = [ inputs.mangobar.packages.${pkgs.system}.default ];
  xdg.configFile."mangobar".source = config.lib.file.mkOutOfStoreSymlink "${dotfile}/mangobar/";
}
