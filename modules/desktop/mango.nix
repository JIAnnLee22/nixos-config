# Mango WM 桌面环境配置
{ config, pkgs, ... }:

let
  user = config.users.users.jiannlee22;
  flakeDir = "${user.home}/nixos-config";
  nixos-rebuild-latest-mango = pkgs.writeShellApplication {
    name = "nixos-rebuild-latest-mango";
    runtimeInputs = with pkgs; [
      nix
      git
    ];
    text = ''
      set -euo pipefail
      flake_dir="''${NIXOS_CONFIG_FLAKE:-${flakeDir}}"
      nix flake update mango --flake "$flake_dir"
      exec sudo nixos-rebuild "$@" --flake "$flake_dir"
    '';
  };
  mango-screenshot = pkgs.writeShellApplication {
    name = "mango-screenshot";
    runtimeInputs = with pkgs; [
      grim
      satty
      wl-clipboard
      config.programs.mango.package
			swaybg
    ];
    text = builtins.readFile ./screenshot.sh;
  };
in
{
  # swaylock PAM is only auto-configured with programs.sway; Mango uses swaylock directly.
  security.pam.services.swaylock = { };

  # 上游 mango NixOS 模块已自带：xdg.portal（wlr/gtk）、xwayland、polkit、登录会话条目，
  # 无需在此重复配置；greetd 基于 tty 启动 Wayland 会话，也不依赖 services.xserver。
  programs.mango.enable = true;

  # 官方推荐 greetd：首次启动自动登录（initial_session），登出后进入 tuigreet 登录界面
  # （default_session）。参考 https://mangowm.github.io/docs/installation#nixos Option A。
  services.greetd = {
    enable = true;
    settings = {
      initial_session = {
        command = "mango";
        user = "${user.name}";
      };
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --cmd mango";
        user = "greeter";
      };
    };
  };

  environment.systemPackages =
    (with pkgs; [
      fuzzel
      cliphist
      wl-clipboard
      wl-clip-persist
      swaybg # autostart.conf 中的壁纸进程，缺它则 exec-once 静默失败
    ])
    ++ [
      nixos-rebuild-latest-mango
      mango-screenshot
    ];
}
