# Home Manager 主配置 - jiannlee22 用户
# 具体功能已拆分到各子模块
{ inputs, pkgs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
  wechat = inputs.wechat.packages.${system}.default;
  wechatWayland = pkgs.symlinkJoin {
    name = "${wechat.name}-wayland-ime";
    paths = [ wechat ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram "$out/bin/wechat" \
        --set QT_QPA_PLATFORM wayland \
        --set QT_IM_MODULE text-input-unstable-v3

      # 使用包装器的绝对路径，避免桌面启动时命中其他 profile 中的同名程序。
      rm "$out/share/applications/wechat.desktop"
      substitute "${wechat}/share/applications/wechat.desktop" \
        "$out/share/applications/wechat.desktop" \
        --replace-fail "Exec=wechat %U" "Exec=$out/bin/wechat %U"
    '';
  };
in
{
  home.username = "jiannlee22";
  home.homeDirectory = "/home/jiannlee22";
  home.stateVersion = "25.11";

  home.packages = [ wechatWayland ];

  imports = [
    # Shell 配置
    ./shell/env.nix
    ./nix.nix
    ./shell/bash.nix

    # 桌面配置
    ./desktop/cursor.nix
    ./desktop/mime.nix

    # 程序配置
    ./programs/jdks.nix
    ./programs/android-studio.nix
    ./programs/pi.nix
    ./programs/swaylock.nix
    ./lsp-servers.nix

    # 服务
    ./services/ssh.nix

    # 输入法
    ./fcitx5-profile.nix

    # mango wm
    ../modules/mangobar
    ../modules/mango

    # 终端和通知
    ./mako.nix
    ./yazi.nix
    ../modules/nvim
  ];
}
