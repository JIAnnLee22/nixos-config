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
  ];
  # clashtui 及 mihomo 后端在 modules/services/clashtui.nix 中统一配置

  programs.bash.enable = true;
}
