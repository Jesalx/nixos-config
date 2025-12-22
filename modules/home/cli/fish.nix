{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}: let
  user = config.home.username;
  home = config.home.homeDirectory;
  nix-helper-app = import ../scripts/nix-helper.nix {inherit pkgs user;};
in {
  options = {
    fish.enable = lib.mkEnableOption "enables custom fish config";
  };
  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;

      # Custom keybindings for fzf-fish
      interactiveShellInit = ''
        set fish_greeting ""

        # Auto-start tmux with 'default' session (only for interactive shells)
        if status is-interactive; and not set -q TMUX
          if tmux has-session -t default 2>/dev/null
            tmux attach-session -t default
          else
            tmux new-session -s default
          end
        end

        # Configure fzf.fish keybindings
        # Ctrl+F for directory, Ctrl+R for history, Ctrl+T for variables
        fzf_configure_bindings --directory=\cf --history=\cr --variables=\ct
      '';

      shellAliases = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux {
          # Linux specific aliases
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          # MacOS specific aliases
        })
        {
          # Common aliases for both platforms
          cd = "z";
          jp-test = "${nix-helper-app}/bin/nix-rebuild test ${userConfig.profile}";
          jp-switch = "${nix-helper-app}/bin/nix-rebuild switch ${userConfig.profile}";
          jp-update = "${nix-helper-app}/bin/nix-rebuild update ${userConfig.profile}";
          jp-clean = "${nix-helper-app}/bin/nix-rebuild clean ${userConfig.profile}";
          nixconfig = "nvim ${home}/nixos-config";
          vimconfig = "nvim ${home}/nixos-config/dotfiles/nvim";
          dt = "ssh jesal@deepthought";
          ls = "eza";
          l = "eza -al";
          ll = "eza -al";
          http = "xh";
          https = "xhs";

          # Workaround for tmux-sessionizer until it's ready for nix
          tms = "/home/${user}/go/bin/tms";
          ts = "/home/${user}/go/bin/tms";
        }
        (lib.mkIf config.development.enable {cat = "bat --paging=never";})
      ];

      shellAbbrs = {
        gg = "jj";
        g = "jj";
        j = "jj";
        xh = "http";
        xhs = "https";
        oc = "opencode";
        v = "nvim";
      };

      functions = {
        y = ''
          set tmp (mktemp -t "yazi-cwd.XXXXXX")
          yazi $argv --cwd-file="$tmp"
          if read -z cwd < "$tmp"; and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
          end
          rm -f -- "$tmp"
        '';
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    home.packages = with pkgs; [
      fishPlugins.fzf-fish
      yazi
    ];
  };
}
