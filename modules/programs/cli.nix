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
    android-cli
  ];

  programs.bash.enable = true;
}
