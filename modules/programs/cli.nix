# CLI 工具
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    wget
    git
    lazygit
    fzf
    tree
    zip
    unzip
    unrar
  ];

  programs.bash.enable = true;
}
