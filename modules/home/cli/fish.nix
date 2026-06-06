{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    fish.enable = lib.mkEnableOption "enables custom fish config";
  };
  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;

      interactiveShellInit = ''
        set fish_greeting ""

        if status is-interactive; and not set -q TMUX
          if tmux has-session -t default 2>/dev/null
            tmux attach-session -t default
          else
            tmux new-session -s default
          end
        end

        fzf_configure_bindings --directory=\cf --history=\cr --variables=\ct
      '';

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
