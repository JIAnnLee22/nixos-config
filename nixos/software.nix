{ pkgs, inputs, ... }:

{
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-39.8.10" # logseq
    ];
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      wqy_microhei
      maple-mono.NF-CN
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      defaultFonts = {
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
          "WenQuanYi Micro Hei"
        ];
        serif = [
          "Noto Serif"
          "Liberation Serif"
          "Noto Serif CJK SC"
          "WenQuanYi Micro Hei"
        ];
        monospace = [
          "Fira Code"
          "Noto Sans Mono CJK SC"
          "WenQuanYi Micro Hei"
        ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  # 设置默认 JDK 版本为 JDK 17
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };

  # 配置图形化 sudo 密码输入
  security.sudo.extraConfig = ''
    # 使用图形化 askpass 程序
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XAUTHORITY"
    Defaults env_keep += "SUDO_ASKPASS"
  '';

  environment.systemPackages = (
    with pkgs;
    [
      htop
      wget
      git
      lazygit
      freerdp
      remmina
      google-chrome
      wechat
      qq
      feishu
      mpv
      qemu_kvm
      pcmanfm
      logseq
      zip
      unzip
      unrar
      tree
      gcc
      foot
      nodejs_24
      # JDK 版本管理
      jdk11
      jdk17
      fzf
      neovim
      # 图形化 askpass 程序
      x11_ssh_askpass
      vial
      # Android Studio 配置已移至 nixos/android-studio.nix
      (st.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "JIAnnLee22";
          repo = "st";
          rev = "ce3fa02a182070bd62b0da82398667d5a365952d";
          sha256 = "sha256-GtIJebINcpVC+W0gy6/KZt9sPGlGnuEzoB7LgzdBqFk=";
        };
      }))
    ]
  );
  programs.bash.enable = true;
}
