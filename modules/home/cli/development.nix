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
      awscli2
      rustup
      nodejs_22
      deno
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
    ];
  };
}
