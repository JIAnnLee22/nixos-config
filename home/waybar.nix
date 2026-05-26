{ ... }:
{
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 32;
      spacing = 8;

      modules-left = [
        "wlr/taskbar"
      ];
      modules-center = [
        "clock"
      ];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
      ];

      clock = {
        format = "{:%H:%M}";
        format-alt = "{:%Y-%m-%d %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
      };

      cpu = {
        format = "CPU {usage}%";
        interval = 5;
      };

      memory = {
        format = "MEM {}%";
        interval = 5;
      };

      pulseaudio = {
        format = "VOL {volume}%";
        format-muted = "MUTE";
        on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
      };

      network = {
        format-wifi = "{essid}";
        format-ethernet = "ETH";
        format-disconnected = "OFF";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      };

      tray = {
        spacing = 8;
      };

      "wlr/taskbar" = {
        format = "{title}";
        max-length = 30;
        on-click = "activate";
      };
    };

    style = ''
      * {
        font-family: monospace;
        font-size: 14px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(32, 27, 20, 0.92);
        color: #c9b890;
      }

      #workspaces button {
        padding: 0 6px;
        color: #888;
        border: none;
        border-radius: 4px;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: #c9b890;
        background-color: rgba(201, 184, 144, 0.15);
      }

      #workspaces button.urgent {
        color: #ad401f;
      }

      #taskbar button {
        padding: 0 6px;
        color: #888;
        border: none;
        border-radius: 4px;
      }

      #taskbar button.active {
        color: #c9b890;
        background-color: rgba(201, 184, 144, 0.15);
      }

      #clock,
      #cpu,
      #memory,
      #pulseaudio,
      #network,
      #tray {
        padding: 0 10px;
      }
    '';
  };
}
