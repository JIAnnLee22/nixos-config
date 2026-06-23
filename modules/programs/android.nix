# Android Studio FHS 环境配置
#
# NixOS 中 Android SDK 工具依赖传统的 Linux 文件系统层次结构（FHS）
# 使用 buildFHSEnv 提供完整的 FHS 目录结构
{ pkgs, ... }:

let
  android-studio-unwrapped = (pkgs.android-studio.override { tiling_wm = true; }).unwrapped;

  android-studio-fhs = pkgs.buildFHSEnv {
    name = "android-studio";
    runScript = "${android-studio-unwrapped}/bin/studio";
    multiPkgs = pkgs: with pkgs; [
      ncurses5
      (pkgs.runCommand "fedoracert" { } ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${pkgs.cacert}/etc/ssl/certs $out/etc/pki/tls/certs
      '')
      zlib
      openssl
      libsecret
      libGL
      libGLU
      libdrm
      mesa
      expat
      fontconfig
      freetype
      gtk2
      glib
      wayland
      cups
    ];
    profile = ''
      export ANDROID_HOME="''${ANDROID_HOME:-$HOME/Android/Sdk}"
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
      export JAVA_HOME="${android-studio-unwrapped}/jbr"
      export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';
    extraInstallCommands = ''
      mkdir -p $out/share/applications
      cat > $out/share/applications/android-studio.desktop << EOF
[Desktop Entry]
Categories=Development;IDE
Comment=The official Android IDE
Exec=android-studio
Icon=android-studio
Name=Android Studio (stable channel)
StartupNotify=true
StartupWMClass=jetbrains-studio
Type=Application
Version=1.5
EOF
      mkdir -p $out/share/icons
      if [ -f "${android-studio-unwrapped}/bin/studio.svg" ]; then
        cp ${android-studio-unwrapped}/bin/studio.svg $out/share/icons/android-studio.svg
      elif [ -f "${android-studio-unwrapped}/bin/studio.png" ]; then
        cp ${android-studio-unwrapped}/bin/studio.png $out/share/icons/android-studio.png
      fi
    '';
  };
in
{
  environment.systemPackages = [
    android-studio-fhs
    pkgs.android-tools
  ];
}
