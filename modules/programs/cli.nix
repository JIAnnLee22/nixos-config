# CLI 工具
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    btop
    wget
    git
    lazygit
    fzf
    tree
    zip
    unzip
    unrar
    zellij
    ripgrep
  ];

  programs.bash.enable = true;
}
