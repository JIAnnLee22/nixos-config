{ pkgs, inputs, ... }:

{
  nixpkgs.config.allowUnfree = true;

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
      rofi
      kitty
      feh
      mpv
      qemu_kvm
      pcmanfm
      logseq
      zip
      unzip
      unrar
      obs-studio
      flameshot
      opencode
      cursor-cli
      frida-tools
      tree
      moonlight-qt
      go
      gcc
      foot
      nodejs_24
      (st.overrideAttrs (oldAttrs: rec {
        src = pkgs.fetchFromGitHub {
          owner = "JIAnnLee22";
          repo = "st";
          rev = "ce3fa02a182070bd62b0da82398667d5a365952d";
          sha256 = "sha256-GtIJebINcpVC+W0gy6/KZt9sPGlGnuEzoB7LgzdBqFk=";
        };
      }))
    ])
    ++ (with inputs.androidShell.packages.${pkgs.stdenv.hostPlatform.system}; [
      as              # rofi 里搜 "Android Studio"
      androidShell11  # 终端命令
      androidShell17  # 终端命令
    ]);
  programs.bash.enable = true;
}
