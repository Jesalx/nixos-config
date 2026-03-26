{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    development.enable = lib.mkEnableOption "enables additional development tools";
  };
  config = lib.mkIf config.development.enable {
    home.packages = with pkgs; [
      tmux
      docker
      podman
      opencode
      gh
      tldr
      act
      lsof
      hyperfine
      nodejs_22
      python3
      uv
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
      terraform
      cockroachdb
      xh
      eza
      mprocs
      nethack
      kubectl
      awscli2
    ];
  };
}
