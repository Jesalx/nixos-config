{
  lib,
  config,
  ...
}: {
  options = {
    starship.enable = lib.mkEnableOption "enables custom starship config";
  };
  config = lib.mkIf config.starship.enable {
    programs.starship.enable = true;
    programs.starship.settings = {
      add_newline = false;
      format = "$all";

      username = {
        style_user = "green bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };

      hostname = {
        ssh_only = false;
        format = "on [$hostname](bold purple) ";
        trim_at = ".";
        disabled = false;
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[✗](bold red)";
      };

      directory = {
        read_only = "  ";
        truncation_length = 10;
        truncate_to_repo = true;
        style = "bold blue";
      };

      cmd_duration.disabled = true;

      aws = {
        symbol = "  ";
      };

      gcloud = {
        disabled = true;
      };

      conda = {
        symbol = " ";
      };

      dart = {
        symbol = " ";
      };

      docker_context = {
        symbol = " ";
        format = "via [$symbol$context]($style) ";
        style = "blue bold";
        only_with_files = true;
        detect_files = [
          "docker-compose.yml"
          "docker-compose.yaml"
          "Dockerfile"
        ];
        detect_folders = [];
        disabled = false;
      };

      elixir = {
        symbol = " ";
      };

      # Native git_branch/git_commit only see git's view of the world. In a
      # jj repo git keeps HEAD detached, so they render useless "HEAD (hash)"
      # noise. Disable them and drive the VCS segment from the custom modules
      # below: jj info in jj repos, git branch everywhere else.
      git_commit.disabled = true;
      git_branch.disabled = true;

      custom = {
        # Plain git repos (not managed by jj): mirror the native git_branch look.
        git_branch = {
          description = "Current git branch (non-jj repos only)";
          when = "git rev-parse --is-inside-work-tree >/dev/null 2>&1 && ! jj root --ignore-working-copy >/dev/null 2>&1";
          shell = ["sh"];
          command = ''b=$(git branch --show-current); [ -z "$b" ] && b=$(git rev-parse --short HEAD 2>/dev/null); printf '%s' "$b"'';
          style = "bold purple";
          format = "on [$output]($style) ";
        };

        # jj repos: show the closest ancestor bookmark (or this change's own)
        # and the working-copy change id, e.g. "main lmvktrkt". Needs shell =
        # ["sh"] because the script is piped to the shell's stdin (a "-c" form
        # would error with "option requires an argument").
        jj = {
          description = "Current jj change";
          when = "jj root --ignore-working-copy >/dev/null 2>&1";
          ignore_timeout = true;
          shell = ["sh"];
          command = ''b=$(jj log --ignore-working-copy --no-graph --color never -r 'latest(heads(::@ & bookmarks()))' -T 'bookmarks.join(",")' 2>/dev/null); c=$(jj log --ignore-working-copy --no-graph --color never -r @ -T 'change_id.shortest(8)' 2>/dev/null); [ -n "$b" ] && printf '%s ' "$b"; printf '%s' "$c"'';
          style = "bold purple";
          format = "on [$output]($style) ";
        };
      };

      git_status = {
        format = ''([\[$all_status$ahead_behind\]]($style) )'';
        stashed = "[\${count}*](green)";
        modified = "[\${count}+](yellow)";
        deleted = "[\${count}-](red)";
        conflicted = "[\${count}~](red)";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        untracked = "[\${count}?](blue)";
        staged = "[\${count}+](green)";
      };

      git_state = {
        style = "bold red";
        format = "[$state( $progress_current/$progress_total) ]($style)";
        rebase = "rebase";
        merge = "merge";
        revert = "revert";
        cherry_pick = "cherry";
        bisect = "bisect";
        am = "am";
        am_or_rebase = "am/rebase";
      };

      golang = {
        symbol = "󰟓 ";
      };

      haskell = {
        symbol = "λ ";
      };

      memory_usage = {
        symbol = " ";
      };

      nim = {
        symbol = " ";
      };

      nix_shell = {
        symbol = " ";
      };

      package = {
        symbol = " ";
      };

      perl = {
        symbol = " ";
      };

      python = {
        symbol = " ";
        format = "via [\${symbol}(\${version} )(\($virtualenv\) )]($style)";
        style = "bold yellow";
        pyenv_prefix = "venv ";
        python_binary = [
          "./venv/bin/python"
          "python"
          "python3"
          "python2"
        ];
        detect_extensions = ["py"];
        # Hacky fix to not show python in $HOME directory by negative matching .config/ directory;
        detect_folders = ["!.config"];
        version_format = "\${raw}";
      };

      ruby = {
        symbol = " ";
      };

      rust = {
        symbol = "🦀 ";
      };

      swift = {
        symbol = " ";
      };

      nodejs = {
        format = "via [  $version](bold green) ";
        detect_files = [
          "package.json"
          ".node-version"
        ];
        detect_folders = ["node_modules"];
      };
    };
  };
}
