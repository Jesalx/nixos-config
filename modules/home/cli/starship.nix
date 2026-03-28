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
      right_format = "$cmd_duration";

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

      cmd_duration = {
        format = "[$duration]($style) ";
        min_time = 4;
        show_milliseconds = false;
        disabled = false;
        style = "bold italic yellow";
      };

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

      git_branch = {
        symbol = " ";
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
