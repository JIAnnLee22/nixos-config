# Home Manager 主配置 - jiannlee22 用户
# 具体功能已拆分到各子模块
{ ... }:

{
  home.username = "jiannlee22";
  home.homeDirectory = "/home/jiannlee22";
  home.stateVersion = "25.11";

  imports = [
    # Shell 配置
    ./shell/env.nix
    ./shell/bash.nix

    # 桌面配置
    ./desktop/cursor.nix
    ./desktop/mime.nix

    # 程序配置
    ./programs/jdks.nix
    ./lsp-servers.nix

    # 服务
    ./services/ssh.nix

    # 输入法
    ./fcitx5-profile.nix

    # Mango WM
    ./mango/config.nix
    ./mango/wallpaper.nix
    ./mango/autostart.nix
    ./mango/bindings.nix
    ./mango/env.nix
    ./mango/rule.nix

    # 终端和状态栏
    ./foot.nix
    ./waybar.nix
    ./mako.nix
  ];
}
