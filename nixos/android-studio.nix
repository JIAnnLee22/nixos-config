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
in
{
  environment.systemPackages = with pkgs; [
    # Android Studio（使用 nixpkgs 默认版本，已内置基础 FHS 包装）
    # 通过 override 开启 tiling_wm 支持（Mango 是平铺窗口管理器）
    (android-studio.override { tiling_wm = true; })

    # 完整 FHS 环境下的 Android Studio 启动器
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
