{ pkgs, ... }:
{
  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withRuby = false;
    withPython3 = false;
  };

  home.packages = with pkgs; [
    fzf
    ripgrep
    stylua
  ];
}
