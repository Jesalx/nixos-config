{
  pkgs,
  lib,
  config,
  ...
}:
let
  volumeScript = import ../scripts/volume.nix { inherit pkgs; };
in
{
  options = {
    waybar.enable = lib.mkEnableOption "enables waybar";
  };
  config = lib.mkIf config.waybar.enable {
    programs.waybar.enable = true;
    # xdg.configFile.waybar.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    home.file.".config/waybar/config.jsonc".text = # json
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
            "modules-left": [
                "custom/arch",
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
                    "memory"
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
            "custom/arch": {
                "format": "",
                "on-click": "kitty --hold -e zsh -c 'paru'",
                "tooltip": false
            }
        }
      '';

    home.file.".config/waybar/style.css".text = # css
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
          font-size: 15px;
          min-height: 15px;
        }

        waybar {
          background: alpha(shade(@background, 0.4), 0);
          min-height: 20px;
        }

        window#waybar {
          /* background: rgba(21, 18, 27, 0); */
          background: alpha(shade(@background, 0.4), 0);
          color: @foreground;
        }

        /* Hide window module when not focused on window or empty workspace */
        window#waybar.empty #window {
          padding: 0px;
          margin: 0px;
          border: 0px;
          background-color: transparent;
        }

        tooltip {
          background: @background;
          border-radius: 10px;
          border-width: 1px;
          border-style: solid;
          border-color: @border-color;
        }

        #workspaces button {
          padding: 2px;
          color: lightblue;
          margin-right: 2px;
        }

        #workspaces button.empty {
          color: @foreground;
        }

        #workspaces button.active {
          color: yellow;
        }

        #custom-arch,
        #custom-power_profile,
        #custom-weather,
        #window,
        #battery,
        #clock,
        #cpu,
        #memory,
        #pulseaudio,
        #network,
        #bluetooth,
        #custom-updates,
        #workspaces,
        #tray,
        #backlight,
        #custom-powermenu {
          background: alpha(@background, 0.8);
          padding: 2px 10px;
          margin: 4px 0px 0px 0px;
        }

        #tray menu,
        tooltip {
          background: @background;
          color: @foreground;
          border: 1px solid shade(@border-color, 0.6);
          border-radius: 10px;
        }

        #backlight {
          border-radius: 10px 0px 0px 10px;
          border: 1px solid @border-color;
          border-right: none;
        }

        #tray {
          border-radius: 10px;
          margin-right: 10px;
          border: 1px solid @border-color;
        }

        #workspaces {
          border-radius: 10px;
          margin-left: 10px;
          padding-right: 2px;
          padding-left: 2px;
          border: 1px solid @border-color;
        }

        #window {
          border-radius: 10px;
          border: 1px solid @border-color;
          margin-left: 10px;
        }

        #memory {
          color: #a6e3a1;
          border-radius: 0px 10px 10px 0px;
          border: 1px solid @border-color;
          margin-right: 10px;
          border-left: none;
        }

        #cpu {
          color: #cba6f7;
          border-radius: 10px 0px 0px 10px;
          border: 1px solid @border-color;
          border-right: none;
        }

        #clock {
          color: #94e2d5;
          border-radius: 10px 0px 0px 10px;
          border: 1px solid @border-color;
          border-right: none;
        }

        #clock.time {
          color: #89b4fa;
          border-radius: 0px 10px 10px 0px;
          border-left: none;
          margin-right: 10px;
          border-right: 1px solid @border-color;
        }

        #custom-arch {
          color: #8be9fd;
          border-radius: 10px 10px 10px 10px;
          margin-left: 8px;
          border-right: 0px;
          padding: 0px 13px 0px 8px;
          border: 1px solid @border-color;
        }

        #pulseaudio {
          color: #fab378;
          border-radius: 10px 0px 0px 10px;
          border: 1px solid @border-color;
          /* border-left: none; */
          border-right: none;
        }

        #pulseaudio.microphone {
          color: #eba0ac;
          border-radius: 0px 10px 10px 0px;
          border-left: none;
          margin-right: 10px;
          border-right: 1px solid @border-color;
        }

        #custom-updates {
          color: #ffb86c;
          border-radius: 10px 10px 10px 10px;
          margin-left: 10px;
          border-left: 0px;
          border: 1px solid @border-color;
        }

        #custom-weather {
          border-radius: 0px 10px 10px 0px;

          margin-left: 0px;
          border-top: 1px solid @border-color;
          border-right: 1px solid @border-color;
          border-bottom: 1px solid @border-color;
        }
      '';
  };
}
