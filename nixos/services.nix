{ ... }:

{
  # JetBrains Toolbox (and many third-party scripts) use shebangs like #!/bin/bash;
  # NixOS does not ship /bin/bash by default, so envfs provides those paths on demand.
  services.envfs.enable = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  nix.settings.auto-optimise-store = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 3;
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
  services.daed = {
    enable = true;
    openFirewall = {
      enable = true;
      port = 12345;
    };
  };

  networking.firewall = {
    enable = true;
    allowPing = true;
    allowedTCPPorts = [ 3389 ];
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # only needed for Wayland -- omit this when using with Xorg
    openFirewall = true;
  };
  hardware.uinput.enable = true;

}
