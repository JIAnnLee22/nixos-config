# dwm X11 桌面；与 mango.nix 二选一，引用本模块即可启用。
{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:

let
  session = pkgs.writeShellApplication {
    name = "dwm-session";
    runtimeInputs = [ pkgs.xinit ];
    text = ''
      export XDG_SESSION_TYPE=x11
      export XDG_CURRENT_DESKTOP=dwm
      export XDG_SESSION_DESKTOP=dwm
      # greetd 使用 VT1；rootless Xorg 必须保留同一控制终端。
      # 显式使用 NixOS 的 xinitrc/xserverrc，不受用户旧 ~/.xinitrc 影响。
      exec startx /etc/X11/xinit/xinitrc -- /etc/X11/xinit/xserverrc :0 vt1 -keeptty
    '';
  };
in
{
  imports = [ inputs.dwm.nixosModules.default ];

  services.xserver = {
    enable = true;
    desktopManager.xterm.enable = false;
    windowManager.dwm = {
      enable = true;
      # 用户路径、锁屏 PATH 和 XDG 自启动适配由 dwm 仓库本身提供。
      package = pkgs.dwm;
      extraSessionCommands = ''
        ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
      '';
    };
    displayManager = {
      lightdm.enable = false;
      startx = {
        enable = true;
        generateScript = true;
        extraCommands = ''
          ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd \
            DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_DESKTOP XDG_SESSION_TYPE
        '';
      };
    };
  };

  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      initial_session = {
        command = lib.getExe session;
        user = config.users.users.jiannlee22.name;
      };
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --cmd ${lib.getExe session}";
        user = "greeter";
      };
    };
  };

  programs.slock.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.polkit.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "gtk" ];
  };

  # 上游 config.def.h 快捷键与 dotfile/dwm/autostart.sh 的运行依赖。
  environment.systemPackages = [
    session
  ]
  ++ (with pkgs; [
    st
    dmenu
    rofi
    feh
    picom
    slstatus
    brightnessctl
    flameshot
    pcmanfm
    qutebrowser
    surf
    tabbed
    xf86-input-synaptics
    maim
    xclip
  ]);
}
