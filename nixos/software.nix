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
      cursor-cli
      opencode
      android-tools
      android-studio
      jetbrains-toolbox
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
  programs.bash.enable = true;

  # JetBrains Toolbox installs generic Linux builds (e.g. Android Studio) that expect a normal
  # dynamic linker + glibc ABI; NixOS otherwise shows the stub-ld error — see
  # https://nix.dev/permalink/stub-ld
  programs.nix-ld.enable = true;
  # Merged with nix-ld’s built-in defaults; these cover JBR/GTK/X11/Wayland needs similar to
  # nixpkgs’ android-studio wrapper.
  programs.nix-ld.libraries = with pkgs; [
    fontconfig
    freetype
    libGL
    libdrm
    libpng
    expat
    libbsd
    dbus
    gtk2
    glib
    libsecret
    udev
    nss_latest
    nspr
    alsa-lib
    libpulseaudio
    wayland
    libxkbcommon
    libxkbfile
    libxcb
    libxcb-wm
    libxcb-render-util
    libxcb-keysyms
    libxcb-image
    libxcb-cursor
    libx11
    libxext
    libxi
    libxrender
    libxtst
    libxrandr
    libxfixes
    libxdamage
    libxcomposite
    libxcursor
    libice
    libsm
    ncurses5
  ];
}
