{
  lib,
  config,
  ...
}: let
  inherit (lib.generators) mkLuaInline;

  # Every `settings` key renders as `hl.<key>(<args>)`. `_args` makes a
  # multi-argument call and `mkLuaInline` emits raw Lua, which is what lets the
  # binds below refer to the `_var` locals by name.
  mkBind = keys: dispatcher: {
    _args = [(mkLuaInline keys) (mkLuaInline dispatcher)];
  };

  mkMouseBind = keys: dispatcher: {
    _args = [(mkLuaInline keys) (mkLuaInline dispatcher) {mouse = true;}];
  };

  superKey = key: ''mainMod .. " + ${key}"'';
  superShiftKey = key: ''mainMod .. " + SHIFT + ${key}"'';

  # Workspaces 1-10 live on keys 1-9 and 0.
  workspaceBinds = lib.concatMap (ws: let
    key = toString (lib.mod ws 10);
  in [
    (mkBind (superKey key) "hl.dsp.focus({ workspace = ${toString ws} })")
    (mkBind (superShiftKey key) "hl.dsp.window.move({ workspace = ${toString ws} })")
  ]) (lib.range 1 10);

  focusBinds = lib.concatMap ({
    keys,
    direction,
  }:
    map (key: mkBind (superKey key) ''hl.dsp.focus({ direction = "${direction}" })'') keys) [
    {
      keys = ["H" "left"];
      direction = "left";
    }
    {
      keys = ["L" "right"];
      direction = "right";
    }
    {
      keys = ["K" "up"];
      direction = "up";
    }
    {
      keys = ["J" "down"];
      direction = "down";
    }
  ];

  specialWorkspaceBinds =
    lib.concatMap ({
      key,
      name,
    }: [
      (mkBind (superKey key) ''hl.dsp.workspace.toggle_special("${name}")'')
      (mkBind (superShiftKey key) ''hl.dsp.window.move({ workspace = "special:${name}" })'')
    ]) [
      {
        key = "S";
        name = "social";
      }
      {
        key = "N";
        name = "notes";
      }
      {
        key = "D";
        name = "term";
      }
    ];

  # `rules` become window rules applied to the spawned client, so the old
  # `[workspace 1 silent]` prefix is a `workspace` rule rather than a separate
  # `silent` key.
  autostart = [
    {cmd = "dunst";}
    {cmd = "hyprpaper";}
    {cmd = "hypridle";}
    {cmd = "waybar";}
    {
      cmd = "ghostty";
      rules = ''{ workspace = "1 silent" }'';
    }
    {
      cmd = "helium-browser";
      rules = ''{ workspace = "1 silent" }'';
    }
    {
      cmd = "ghostty";
      rules = ''{ workspace = "special:term silent" }'';
    }
    {
      cmd = "obsidian";
      rules = ''{ workspace = "special:notes silent" }'';
    }
  ];

  renderAutostart = {
    cmd,
    rules ? null,
  }: ''hl.exec_cmd("${cmd}"${lib.optionalString (rules != null) ", ${rules}"})'';
in {
  options = {
    hyprland.enable = lib.mkEnableOption "enables custom hyprland config";
  };
  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        # Rendered as Lua locals, so the binds below can reference them.
        browser = {_var = "helium-browser";};
        terminal = {_var = "ghostty";};
        fileManager = {_var = "nautilus";};
        menu = {_var = "pkill fuzzel || fuzzel";};
        mainMod = {_var = "SUPER";};

        monitor = [
          {
            output = "HDMI-A-1";
            mode = "highres";
            position = "0x0";
            scale = 1.5;
          }
          {
            output = "DP-2";
            mode = "2560x1440@360";
            position = "auto";
            scale = 1;
          }
          {
            output = "";
            mode = "preferred";
            position = "auto";
            scale = "auto";
          }
        ];

        config = {
          general = {
            # See https://wiki.hypr.land/Configuring/Variables/ for more
            gaps_in = 5;
            gaps_out = 8;
            border_size = 2;
            col = {
              active_border = {
                colors = ["rgba(d972ffee)" "rgba(3772ffee)"];
                angle = 45;
              };
              inactive_border = "rgba(595959aa)";
            };

            layout = "dwindle";

            # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
            allow_tearing = false;
          };

          decoration = {
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

          input = {
            kb_layout = "us";
            kb_options = "ctrl:nocaps";
            follow_mouse = 1;
            mouse_refocus = false;
            accel_profile = "flat";

            touchpad.natural_scroll = false;

            sensitivity = 0.2; # -1.0 - 1.0, 0 means no modification.
          };

          misc = {
            force_default_wallpaper = 0; # Set to 0 to disable the anime mascot wallpapers
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
            disable_splash_rendering = true;
            focus_on_activate = true;
            vrr = 2;
          };

          dwindle.preserve_split = true;

          animations.enabled = true;
        };

        # `curve` is in `importantPrefixes`, so it is emitted before `animation`;
        # an animation that names a not-yet-defined curve is a config error.
        curve = [
          {
            _args = [
              "myBezier"
              {
                type = "bezier";
                points = [[0.05 0.9] [0.1 1.05]];
              }
            ];
          }
        ];

        animation = [
          {
            leaf = "windows";
            enabled = true;
            speed = 7;
            bezier = "myBezier";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 7;
            bezier = "default";
            style = "popin 80%";
          }
          {
            leaf = "border";
            enabled = true;
            speed = 10;
            bezier = "default";
          }
          {
            leaf = "borderangle";
            enabled = true;
            speed = 8;
            bezier = "default";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 7;
            bezier = "default";
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 6;
            bezier = "default";
          }
        ];

        window_rule = [
          {
            match = {
              class = "firefox";
              fullscreen = true;
            };
            idle_inhibit = "fullscreen";
          }
          {
            match.class = "mpv";
            idle_inhibit = "focus";
          }
        ];

        workspace_rule =
          map (ws: {
            workspace = toString ws;
            monitor = "DP-2";
          }) (lib.range 1 9)
          ++ [
            {
              workspace = "10";
              monitor = "HDMI-A-1";
            }
          ];

        bind =
          [
            (mkBind (superKey "RETURN") "hl.dsp.exec_cmd(terminal)")
            (mkBind (superKey "B") "hl.dsp.exec_cmd(browser)")
            (mkBind (superKey "Q") "hl.dsp.window.close()")
            (mkBind (superKey "E") "hl.dsp.exec_cmd(fileManager)")
            (mkBind (superKey "V") ''hl.dsp.window.float({ action = "toggle" })'')
            (mkBind (superKey "F") "hl.dsp.window.fullscreen()")
            (mkBind (superKey "SPACE") "hl.dsp.exec_cmd(menu)")

            # Take a screenshot
            (mkBind (superKey "P") ''hl.dsp.exec_cmd("hyprshot -m region")'')

            # Scroll through existing workspaces with mainMod + scroll
            (mkBind (superKey "mouse_down") ''hl.dsp.focus({ workspace = "e+1" })'')
            (mkBind (superKey "mouse_up") ''hl.dsp.focus({ workspace = "e-1" })'')

            # Mouse macro keybindings
            (mkBind ''"CONTROL + right"'' ''hl.dsp.focus({ workspace = "e+1" })'')
            (mkBind ''"CONTROL + left"'' ''hl.dsp.focus({ workspace = "e-1" })'')
            (mkBind ''"CONTROL + up"'' ''hl.dsp.workspace.toggle_special("social")'')

            (mkMouseBind (superKey "mouse:272") "hl.dsp.window.drag()")
            (mkMouseBind (superKey "mouse:273") "hl.dsp.window.resize()")
          ]
          ++ focusBinds
          ++ workspaceBinds
          ++ specialWorkspaceBinds;
      };

      # Home Manager emits `extraConfig` after its own `hyprland.start` hook but
      # `settings.on` before it, and the autostarted clients expect the D-Bus and
      # systemd environment to already be populated, as it was under hyprlang.
      extraConfig = ''
        hl.on("hyprland.start", function()
        ${lib.concatMapStringsSep "\n" renderAutostart autostart}
        end)
      '';
    };
  };
}
