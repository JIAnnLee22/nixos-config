# Android Studio FHS 环境配置
#
# NixOS 中 Android SDK 工具（emulator、adb、sdkmanager 等）依赖传统的 Linux
# 文件系统层次结构（FHS），需要 /lib/ld-linux.so.2 等路径。
#
# 解决方案分两层：
#   1. nix-ld  — 提供动态链接器兼容性，让 SDK 预编译二进制文件可以运行
#   2. buildFHSEnv — 提供完整的 FHS 目录结构（/lib、/usr/lib 等）
#
# 你也可以通过终端运行 `android-studio-fhs` 启动完整 FHS 环境下的 Android Studio。
{ pkgs, ... }:

let
  # Android Studio 原始包（未包装 FHS）
  android-studio-unwrapped = (pkgs.android-studio.override { tiling_wm = true; }).unwrapped;

  # 构建一个完整的 FHS 环境，包含 Android SDK 工具所需的全部库
  android-studio-fhs = pkgs.buildFHSEnv {
    name = "android-studio-fhs";
    runScript = "android-studio";
    # multiPkgs 同时提供 x86_64 和 i686 库（mksdcard 等 32 位工具需要）
    multiPkgs = pkgs: with pkgs; [
      # 终端工具（sdkmanager 的进度条等）
      ncurses5

      # SSL 证书 — Flutter 的 sdkmanager 按 Fedora 风格查找证书
      (pkgs.runCommand "fedoracert" { } ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${pkgs.cacert}/etc/ssl/certs $out/etc/pki/tls/certs
      '')

      # 基础运行时库
      zlib
      openssl
      libsecret

      # 图形 / X11（模拟器窗口渲染）
      libGL
      libGLU
      libdrm
      mesa
      expat
      fontconfig
      freetype

      # GTK 外观
      gtk2
      glib

      # Wayland
      wayland

      # 打印支持
      cups
    ];
    profile = ''
      export ANDROID_HOME="''${ANDROID_HOME:-$HOME/Android/Sdk}"
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
    '';
  };

  # 完整 FHS 环境下的 Android Studio（默认版本）
  android-studio-full-fhs = pkgs.buildFHSEnv {
    name = "android-studio";
    runScript = "${android-studio-unwrapped}/bin/studio";
    # multiPkgs 同时提供 x86_64 和 i686 库（mksdcard 等 32 位工具需要）
    multiPkgs = pkgs: with pkgs; [
      # 终端工具（sdkmanager 的进度条等）
      ncurses5

      # SSL 证书 — Flutter 的 sdkmanager 按 Fedora 风格查找证书
      (pkgs.runCommand "fedoracert" { } ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${pkgs.cacert}/etc/ssl/certs $out/etc/pki/tls/certs
      '')

      # 基础运行时库
      zlib
      openssl
      libsecret

      # 图形 / X11（模拟器窗口渲染）
      libGL
      libGLU
      libdrm
      mesa
      expat
      fontconfig
      freetype

      # GTK 外观
      gtk2
      glib

      # Wayland
      wayland

      # 打印支持
      cups
    ];
    profile = ''
      export ANDROID_HOME="''${ANDROID_HOME:-$HOME/Android/Sdk}"
      export ANDROID_SDK_ROOT="$ANDROID_HOME"
      export JAVA_HOME="${android-studio-unwrapped}/jbr"
      export QT_XKB_CONFIG_ROOT="${pkgs.xkeyboard_config}/share/X11/xkb"
      export _JAVA_AWT_WM_NONREPARENTING=1
    '';

    # 添加桌面文件
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
      # 复制图标
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
  environment.systemPackages = with pkgs; [
    # Android Studio（完整 FHS 环境版本，作为默认启动方式）
    android-studio-full-fhs

    # 完整 FHS 环境下的 Android Studio 启动器（备用）
    # 终端运行 `android-studio-fhs` 即可启动
    android-studio-fhs

    # Android 命令行工具（adb、fastboot）
    android-tools
  ];

  # nix-ld: 为 NixOS 上的预编译二进制文件提供动态链接器兼容性
  # Android SDK 中的工具（如 emulator、aapt2、lldb）在编译时假设存在
  # /lib64/ld-linux-x86-64.so.2 和标准 FHS 路径，nix-ld 解决此问题
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      # 核心 C++ 运行时
      stdenv.cc.cc.lib

      # 压缩 / 加密
      zlib
      openssl

      # 密钥环（存储 SDK 登录凭据）
      libsecret

      # 字体渲染（IDE 和 SDK 工具 UI）
      fontconfig
      freetype

      # 图形
      libGL
      expat

      # 网络 / 安全
      nspr
      nss

      # 终端
      ncurses5

      # X11 基础
      libX11
      libXext
      libXrender
      libXtst
      libXi
      libXrandr

      # Wayland
      wayland

      # GTK
      gtk2
      glib
    ];
  };
}
