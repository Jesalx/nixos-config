{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables custom hyprland config";
  };
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        monitor = [
          "HDMI-A-1, highres,0x0,1.5"
          "DP-2, 2560x1440@360,auto,1"
          ",preferred,auto,auto"
        ];

        exec-once = [
          "dunst"
          "hyprpaper"
          "hypridle"
          "waybar"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "rm $HOME/.cache/cliphist/db # delete clipboard history every boot"

          "[workspace 1 silent] ghostty"
          "[workspace 1 silent] firefox"
          "[workspace special:term silent] ghostty"
          "[workspace special:notes silent] obsidian"
        ];

        "$browser" = "firefox";
        "$terminal" = "ghostty";
        "$fileManager" = "nautilus";
        "$menu" = "pkill wofi || wofi -c /home/jesal/.config/wofi/config -I -a";

        input = {
          kb_layout = "us";
          kb_options = "ctrl:nocaps";
          follow_mouse = 1;
          mouse_refocus = false;
          accel_profile = "flat";

          touchpad = {
            natural_scroll = "no";
          };

          sensitivity = 0.2; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          gaps_in = 5;
          gaps_out = 8;
          border_size = 2;
          "col.active_border" = "rgba(d972ffee) rgba(3772ffee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10;

          blur = {
            enabled = true;
            size = 8;
            passes = 1;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };

        };

        animations = {
          enabled = "yes";
          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = "yes"; # you probably want this
        };

        master = {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          # new_is_master = true
        };

        gestures = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = "off";
        };

        misc = {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
          disable_splash_rendering = true;
          vrr = 2;
        };

        windowrulev2 = [
          "idleinhibit fullscreen, class:firefox, fullscreen:1"
          "idleinhibit focus, class:mpv"
          "opacity 0.85,class:^(kitty)$"
        ];

        "$mainMod" = "SUPER";
        bind = [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, B, exec, $browser"
          "$mainMod, Q, killactive, "
          # bind = $mainMod, BACKSPACE, exit,
          "$mainMod, E, exec, $fileManager"
          "$mainMod, V, togglefloating, "
          "$mainMod, F, fullscreen, "
          # bind = $mainMod, R, exec, $menu
          "$mainMod, SPACE, exec, $menu"
          # bind = $mainMod, P, pseudo, # dwindle
          # bind = $mainMod, J, togglesplit, # dwindle

          # Move focus with mainMod + vim directional keys
          "$mainMod, H, movefocus, l"
          "$mainMod, L, movefocus, r"
          "$mainMod, K, movefocus, u"
          "$mainMod, J, movefocus, d"

          # Move focus with mainMod + arrow keys
          "$mainMod, left, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, down, movefocus, d"

          # Switch workspaces with mainMod + [0-9]
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          # Take a screenshot
          "$mainMod, P, exec, $XDG_CONFIG_HOME/hypr/scripts/screenshot.sh"

          # Move active window to a workspace with mainMod + SHIFT + [0-9]
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          # Special workspace (social)
          "$mainMod, S, togglespecialworkspace, social"
          "$mainMod SHIFT, S, movetoworkspace, special:social"

          # Special workspace (notes)
          "$mainMod, N, togglespecialworkspace, notes"
          "$mainMod SHIFT, N, movetoworkspace, special:notes"

          # Special workspace (term)
          "$mainMod, D, togglespecialworkspace, term"
          "$mainMod SHIFT, D, movetoworkspace, special:term"

          # Scroll through existing workspaces with mainMod + scroll
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"

          # Mouse macro keybindings
          "CONTROL, right, workspace, e+1"
          "CONTROL, left, workspace, e-1"
          "CONTROL, up, togglespecialworkspace, social"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];

        workspace = [
          "1, monitor:DP-2"
          "2, monitor:DP-2"
          "3, monitor:DP-2"
          "4, monitor:DP-2"
          "5, monitor:DP-2"
          "6, monitor:DP-2"
          "7, monitor:DP-2"
          "8, monitor:DP-2"
          "9, monitor:DP-2"
          "10, monitor:HDMI-A-1"
        ];

      };
    };
  };
}
