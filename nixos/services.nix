{ pkgs, ... }:

{
  services.envfs.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  nix.settings.trusted-users = [ "root" "jiannlee22" ];
  nix.settings.substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.sshd.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # daed
  environment.systemPackages = [ pkgs.daed ];
  systemd.packages = [ pkgs.daed ];
  systemd.services.daed = {
    wantedBy = [ "multi-user.target" ];
    preStart = ''
      umask 0077
      mkdir -p /etc/daed
      ln -sfn ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat /etc/daed/
      ln -sfn ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat /etc/daed/
    '';
    serviceConfig.ExecStart = [
      ""
      "${pkgs.daed}/bin/daed run -c /etc/daed -l 127.0.0.1:2023"
    ];
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 12345 3389 ];
    allowedUDPPorts = [ 12345 ];
  };

  hardware.uinput.enable = true;
}
