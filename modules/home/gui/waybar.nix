{
  pkgs,
  lib,
  config,
  ...
}: let
  volumeScript = import ../scripts/volume.nix {inherit pkgs;};
in {
  options = {
    waybar.enable = lib.mkEnableOption "enables waybar";
  };
  config = lib.mkIf config.waybar.enable {
    programs.waybar.enable = true;
    # xdg.configFile.waybar.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    home.file.".config/waybar/config.jsonc".text =
      # json
      ''
        {
            "output": "DP-2",
            "layer": "top",
            "position": "top",
            "mod": "dock",
            "exclusive": true,
            "passthrough": false,
            "gtk-layer-shell": true,
            "height": 35,
            "margin": "5px 10px 0 10px",
            "modules-left": [
                "custom/nix",
                "hyprland/workspaces"
            ],
            "modules-center": [
                "hyprland/window"
            ],
            "modules-right": [
                "tray",
                "group/hardware",
                "pulseaudio",
                "pulseaudio#microphone",
                "group/time"
            ],
            "hyprland/window": {
                "format": "{}",
                "max-length": 70
            },
            "hyprland/workspaces": {
                "format": "{icon}",
                "on-click": "activate",
                "all-outputs": true,
                "persistent-workspaces": {
                    "1": [],
                    "2": [],
                    "3": [],
                    "4": [],
                    "5": [],
                    "6": [],
                    "7": [],
                    "8": [],
                    "9": [],
                    "10": []
                },
                "format-icons": {
                    "active": "󰮯",
                    "default": "󰊠",
                    "empty": ""
                }
            },
            "tray": {
                "icon-size": 19,
                "spacing": 10
            },
            "group/hardware": {
                "orientation": "horizontal",
                "modules": [
                    "cpu",
                    "memory",
                    "disk"
                ]
            },
            "group/time": {
                "orientation": "horizontal",
                "modules": [
                    "clock#date",
                    "clock#time"
                ]
            },
            "clock#time": {
                "format": " {:%I:%M %p}",
                "interval": 60
            },
            "clock#date": {
                "format": " {:%Y/%m/%d}",
                "tooltip-format": "<tt><small>{calendar}</small></tt>",
                "interval": 300,
                "calendar": {
                    "mode": "month",
                    "mode-mon-col": 3,
                    "weeks-pos": "right",
                    "on-scroll": 1,
                    "on-click-right": "mode",
                    "format": {
                        "today": "<span color='#a6e3a1'><b><u>{}</u></b></span>"
                    }
                }
            },
            "pulseaudio": {
                "format": "{icon} {volume}%",
                "format-muted": " Muted",
                "on-click": "${volumeScript}/bin/volume-control toggle",
                "on-click-middle": "pavucontrol",
                "on-scroll-up": "${volumeScript}/bin/volume-control up",
                "on-scroll-down": "${volumeScript}/bin/volume-control down",
                "format-icons": {
                    "phone": "",
                    "portable": "",
                    "car": "",
                    "default": [
                        "",
                        "",
                        ""
                    ]
                }
            },
            "pulseaudio#microphone": {
                "format": "{format_source}",
                "format-source": " {volume}%",
                "format-source-muted": " Muted",
                "on-click": "pactl set-source-mute 0 toggle",
                "on-scroll-up": "pactl set-source-volume 0 +1%",
                "on-scroll-down": "pactl set-source-volume 0 -1%"
            },
            "memory": {
                "format": " {}%",
                "interval": 30
            },
            "disk": {
                "format": " {percentage_used}%",
                "interval": 600
            },
            "cpu": {
                "format": " {usage}%",
                "on-click": "kitty btm",
                "interval": 10
            },
            "temperature": {
                "thermal-zone": 1,
                "format": "{temperatureF}°F ",
                "critical-threshold": 80,
                "format-critical": "{temperatureC}°C "
            },
            "custom/nix": {
                "format": "",
                "on-click": "hyprlock",
                "tooltip": false
            }
        }
      '';

    home.file.".config/waybar/style.css".text =
      # css
      ''
        @define-color foreground #e5e0dc;
        @define-color background #0d0e0d;
        @define-color border-color #0d0e0d;

        * {
          background: transparent;
          border: none;
          border-radius: 0;
          font-family: "JetBrainsMono Nerd Font";
          font-weight: bold;
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(10, 10, 10, 0.8);
          color: @foreground;
          border-radius: 10px;
        }

        tooltip {
          background: @background;
          border-radius: 10px;
          border-width: 1px;
          border-style: solid;
          border-color: @border-color;
        }

        #workspaces button {
          padding: 0 5px;
          color: lightblue;
        }

        #workspaces button.empty {
          color: @foreground;
        }

        #workspaces button.active {
          color: yellow;
        }

        #workspaces,
        #custom-nix,
        #window,
        #cpu,
        #memory,
        #disk,
        #pulseaudio,
        #clock,
        #tray {
          padding: 0 10px;
        }

        /* Center the content vertically */
        #workspaces button,
        #custom-nix,
        #window,
        #cpu,
        #memory,
        #disk,
        #pulseaudio,
        #clock,
        #tray {
          margin: 2px 0;
        }

        #tray menu {
          background: @background;
          color: @foreground;
          border: 1px solid shade(@border-color, 0.6);
          border-radius: 10px;
        }

        #workspaces {
          margin-left: 5px;
        }

        #window {
          margin-left: 5px;
          margin-right: 5px;
        }

        #cpu {
          color: #4bbbe3;
        }

        #memory {
          color: #a6e3a1;
        }

        #disk {
          color: #cba6f7;
        }

        #clock {
          color: #94e2d5;
        }

        #clock.time {
          color: #89b4fa;
        }

        #custom-nix {
          color: #8be9fd;
          margin-left: 5px;
        }

        #pulseaudio {
          color: #fab378;
        }

        #pulseaudio.microphone {
          color: #eba0ac;
        }

        #custom-updates {
          color: #ffb86c;
        }

        #tray {
          margin-right: 5px;
        }
      '';
  };
}
