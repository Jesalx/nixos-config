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
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      rustup
      nodejs_22
      pyenv
      python3
      go
      gcc
      gnumake
      unzip
      wget
      curl
      ripgrep
      fd
      fzf
      alejandra
    ];
  };
}