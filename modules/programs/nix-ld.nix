{ pkgs, ... }:

{
  # nix-ld: 允许运行未修补的动态链接程序（如 npm 全局安装的 CLI 工具）
  # 解决 "NixOS cannot run dynamically linked executables" 错误
  programs.nix-ld = {
    enable = true;
    
    # 提供常用的共享库，使大多数动态链接程序能够运行
    libraries = with pkgs; [
      # 基础 C 库和动态链接器
      stdenv.cc.cc.lib
      glibc
      
      # 常用系统库
      zlib
      bzip2
      openssl
      libkrb5
      icu
      
      # 图形相关（某些 CLI 工具可能需要）
      libGL
      libdrm
      mesa
      
      # X11 相关
      xorg.libX11
      xorg.libXext
      xorg.libXi
      xorg.libXrender
      xorg.libXtst
      xorg.libXrandr
      xorg.libICE
      xorg.libSM
      
      # Wayland 相关
      wayland
      wayland-protocols
      
      # 字体和渲染
      fontconfig
      freetype
      cairo
      pango
      harfbuzz
      
      # 其他常见依赖
      atk
      at-spi2-atk
      at-spi2-core
      gtk3
      gdk-pixbuf
      glib
      dbus
      nss
      nspr
      cups
      libxkbcommon
      expat
      libuuid
    ];
  };
}
