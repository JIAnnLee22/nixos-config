{ pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      jdk11 = prev.javaPackages.compiler.openjdk11;
      jdk17 = prev.javaPackages.compiler.openjdk17;
    })
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
      fira-code
      jetbrains-mono
      noto-fonts
      wqy_microhei
      wqy_zenhei
      texlivePackages.noto-emoji
      source-han-sans
    ];

    fontconfig = {
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default";
      defaultFonts = {
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "WenQuanYi Micro Hei" ];
        serif = [ "Noto Serif" "Liberation Serif" "Noto Serif CJK SC" "WenQuanYi Micro Hei" ];
        monospace = [ "Fira Code" "JetBrains Mono" "Noto Sans Mono CJK SC" "WenQuanYi Micro Hei" ];
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };

  environment.systemPackages =
    (with pkgs; [
      vim
      neovim
      htop
      wget
      git
      lazygit
      javaPackages.compiler.openjdk11
      javaPackages.compiler.openjdk17
      freerdp
      remmina
      google-chrome
      wechat
      qq
      feishu
      android-studio
      rofi
      kitty
      feh
      mpv
      picom
      dunst
      xrandr
      qemu_kvm
      pcmanfm
      logseq
      zip
      unzip
      unrar
      obs-studio
      flameshot
      cursor-cli
      claude-code
      opencode
      android-tools
      unityhub
      (st.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "JIAnnLee22";
          repo = "st";
          rev = "ce3fa02a182070bd62b0da82398667d5a365952d";
          sha256 = "sha256-GtIJebINcpVC+W0gy6/KZt9sPGlGnuEzoB7LgzdBqFk=";
        };
      }))
    ]);

  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };
}
