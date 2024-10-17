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
      rustup
      nodejs_22
      deno
      pyenv
      python3
      go_1_23
      crystal
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
      mongosh
      zig
      zls
    ];
  };
}
