{ pkgs, ... }:

{
  home.packages = with pkgs; [
    pamixer
    wlogout
  ];

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings.mainBar = {
      layer = "top";
      height = 42;
      spacing = 4;

      modules-left = [
        "ext/workspaces"
        "wlr/taskbar"
        "dwl/window"
      ];
      modules-center = [ ];
      modules-right = [
        "network"
        "cpu"
        "memory"
        "temperature"
        "pulseaudio"
        "backlight"
        "clock"
        "custom/power"
        "tray"
      ];

      "dwl/window" = {
        format = "[{layout}]{title}";
        on-click = "mango-screenshot";
      };

      "ext/workspaces" = {
        format = "{icon}";
        ignore-hidden = true;
        on-click = "activate";
        on-click-right = "deactivate";
        on-scroll-up = "mmsg -d viewtoleft_have_client";
        on-scroll-down = "mmsg -d viewtoright_have_client";
        sort-by-id = true;
      };

      "wlr/taskbar" = {
        format = "{icon}";
        icon-size = 20;
        all-outputs = false;
        tooltip-format = "{title}";
        markup = true;
        on-click = "activate";
        on-click-right = "close";
        ignore-list = [
          "Rofi"
          "wofi"
        ];
      };

      network = {
        interval = 2;
        format-wifi = "{essid} ({signalStrength}%) \\uf1eb";
        format-ethernet = "󰈀 {ifname}";
        format-linked = "\\uf059 No IP ({ifname})";
        format-disconnected = "\\uf071 Disconnected";
        tooltip-format = "{ifname} {ipaddr}/{cidr} via {gwaddr}";
        format-alt = "↓{bandwidthDownBytes} ↑{bandwidthUpBytes}";
      };

      tray = {
        icon-size = 21;
        spacing = 10;
      };

      clock = {
        format = " {:%Y-%m-%d %H:%M:%S}";
        interval = 1;
      };

      cpu = {
        interval = 2;
        format = " {load}%";
      };

      memory = {
        format = " {}%";
      };

      temperature = {
        critical-threshold = 90;
        format = "{icon} {temperatureC}°C";
        tooltip = true;
        tooltip-format = "{temperatureF}°F";
        format-icons = [
          ""
          ""
          ""
        ];
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = [
          "󰖔"
          "󰖨"
        ];
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        tooltip = false;
        format-muted = " Muted";
        on-click = "pamixer -t";
        on-scroll-up = "pamixer -i 2";
        on-scroll-down = "pamixer -d 2";
        scroll-step = 5;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = [
            ""
            ""
            ""
          ];
        };
      };

      "custom/power" = {
        format = "󰣇";
        tooltip = false;
        on-click = "wlogout -l ~/.config/mango/wlogout/layout -b 6 --protocol layer-shell";
      };
    };

    style = builtins.readFile ./waybar/style.css;
  };
}
