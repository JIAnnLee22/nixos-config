# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, st, ... }:

let
  stPkg = st.packages.${pkgs.system}.default;
in
{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.substituters = [ "https://mirror.nju.edu.cn/nix-channels/store" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Configure bluetooth connections interactively with blueman.
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-chinese-addons
      fcitx5-gtk
    ];
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager.runXdgAutostartIfNone = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm.enable = true;
  # services.displayManager.sddm.wayland.enable = true;

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.overrideAttrs {
      src = pkgs.fetchFromGitHub {
        owner = "JIAnnLee22";
        repo = "dwm";
        rev = "cd24932c249d4eedc6c2605e01ee1461b438d7f2";
        hash = "sha256-t34+uPYuYjpMXpt/KfBcS4K0mV/1WEXhCeeM8yC37Rw=";
      };
      # src = /home/jiannlee22/Project/dwm;
    };
  };
  services.displayManager.defaultSession = "none+dwm";

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  services.v2raya.enable = true;
  # services.dae = {
  #   enable = true;
  #   configFile = "/home/jiannlee22/.config/dea/config.dae";
  #   assets = with pkgs; [
  #     v2ray-geoip
  #     v2ray-domain-list-community
  #   ];
  #   openFirewall = {
  #     enable = true;
  #     port = 12345;
  #   };
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.jiannlee22 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "kvm" "adbusers" "samba" ]; # Enable ‘sudo’ for the user.
  };
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

      fira-code              # 可选：Fira Code，经典的编程连字字体
      jetbrains-mono         # 可选：JetBrains Mono，清晰易读
  
      # 中文字体 (确保中文清晰显示)
      noto-fonts         # Google Noto字体，覆盖广，显示效果均衡
      wqy_microhei           # 文泉驿微米黑，屏幕显示清晰
      wqy_zenhei             # 文泉驿正黑
  
      # 表情符号字体
      texlivePackages.noto-emoji
      source-han-sans
    ];
  
    fontconfig = {
      # 字体渲染优化
      antialias = true;
      hinting.enable = true;
      subpixel.lcdfilter = "default"; # 对LCD屏幕进行优化，可根据屏幕类型调整（如"rgb", "bgr", "none"）
  
      # 设置默认字体族及回退顺序
      defaultFonts = {
        # 无衬线字体（用于界面、标题等）
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" "WenQuanYi Micro Hei" ];
        # 衬线字体（用于正文阅读）
        serif = [ "Noto Serif" "Liberation Serif" "Noto Serif CJK SC" "WenQuanYi Micro Hei" ];
        # 等宽字体（用于编程、终端）
        monospace = [ "Fira Code" "JetBrains Mono" "Noto Sans Mono CJK SC" "WenQuanYi Micro Hei" ];
        # 表情符号
        emoji = [ "Noto Color Emoji" ];
      };
    };
  };
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
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
    v2raya
    wechat-uos
    qq
    feishu
    android-studio
    rofi
    kitty
    feh
    mpv
    picom
    dunst
    xorg.xrandr
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
    stPkg
  ];
  nixpkgs.overlays = [
    (final: prev: {
      jdk11 = prev.javaPackages.compiler.openjdk11;
      jdk17 = prev.javaPackages.compiler.openjdk17;
    })
  ];
  programs.adb.enable = true;
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedTCPPortRanges = [ ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = true;
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "LJA File Server";
        "netbios name" = "smbnix";
        "security" = "user";
        #"use sendfile" = "yes";
        #"max protocol" = "smb2";
        # note: localhost is the ipv6 localhost ::1
        "hosts allow" = "192.168.0. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest" = "never";
      };
      "private" = {
        "path" = "/mnt/shares/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "nobody";
        "force group" = "nogroup";
        "valid users" = "jiannlee22";
	"writeable" = "yes";
	"write list" = "jiannlee22";
      };
    };
  };
  
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  
  services.avahi = {
    publish.enable = true;
    publish.userServices = true;
    # ^^ Needed to allow samba to automatically register mDNS records (without the need for an `extraServiceFile`
    nssmdns4 = true;
    # ^^ Not one hundred percent sure if this is needed- if it aint broke, don't fix it
    enable = true;
    openFirewall = true;
  };
  
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

}

