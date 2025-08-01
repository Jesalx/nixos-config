{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    development.enable = lib.mkEnableOption "enables additional development tools";
  };
  config = lib.mkIf config.development.enable {

    home.packages = with pkgs; [
      tmux
      docker
      hyperfine
      awscli2
      rustup
      nodejs_22
      pyenv
      python3
      uv
      go
      gopls
      golangci-lint
      crystal
      shards
      crystalline
      gcc
      gnumake
      unzip
      wget
      curl
      ripgrep
      go-task
      fd
      fzf
      alejandra
      jq
      bat
      vscode
      zig
      zls
      terraform
      qmk
      via
      cockroachdb
      chromium
      keymapp
      hyprshot
      xh
      httpie-desktop
      eza
      mprocs
      claude-code
    ];
  };
}
