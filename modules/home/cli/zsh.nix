{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    zsh.enable = lib.mkEnableOption "enables custom zsh config";
  };
  config = lib.mkIf config.zsh.enable {
    programs = {
      zsh = {
        enable = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        enableCompletion = true;
        historySubstringSearch.enable = true;

        shellAliases = {
          gg = "jj";
          g = "jj";
          j = "jj";
          oc = "opencode";
          v = "nvim";
        };

        history = {
          size = 100000;
          save = 100000;
          ignoreDups = true;
          ignoreSpace = true;
          share = true;
          extended = true;
          path = "${config.xdg.dataHome}/zsh/history";
        };

        initContent = ''
          if [[ -z "$TMUX" ]]; then
            if tmux has-session -t default 2>/dev/null; then
              tmux attach-session -t default
            else
              tmux new-session -s default
            fi
          fi

          bindkey '^P' history-substring-search-up
          bindkey '^N' history-substring-search-down
          bindkey '^F' fzf-cd-widget

          y() {
            local tmp cwd
            tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
            yazi "$@" --cwd-file="$tmp"
            cwd="$(<"$tmp")"
            if [[ -n "$cwd" ]] && [[ "$cwd" != "$PWD" ]]; then
              builtin cd -- "$cwd"
            fi
            rm -f -- "$tmp"
          }
        '';
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;

        defaultOptions = [
          "--height=60%"
          "--layout=reverse"
          "--border=rounded"
          "--info=inline-right"
          "--pointer=▶"
          "--marker=◆"
          "--scrollbar=▍"
        ];

        historyWidgetOptions = [
          "--exact"
          "--bind=ctrl-u:half-page-up,ctrl-d:half-page-down"
        ];
      };

      zoxide.enableZshIntegration = true;
    };

    home.packages = with pkgs; [
      yazi
    ];
  };
}
