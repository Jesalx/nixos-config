{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ghostty.enable = lib.mkEnableOption "enables custom ghostty config";
  };
  config = lib.mkIf config.ghostty.enable {
    xdg.configFile."ghostty/config".text = ''
      shell-integration = fish
      background = 080808
      window-decoration = false
      gtk-titlebar = false
      font-family = Berkeley Mono Variable
      # https://github.com/srcery-colors/srcery-terminal/
      foreground = #fce8c3
      selection-foreground = #1c1b19
      selection-background = #fce8c3

      palette = 0=#1c1b19
      palette = 1=#ef2f27
      palette = 2=#519f50
      palette = 3=#fbb829
      palette = 4=#2c78bf
      palette = 5=#d63e3c
      palette = 6=#0aaeb3
      palette = 7=#baa67f
      palette = 8=#918175
      palette = 9=#f75341
      palette = 10=#98bc37
      palette = 11=#fed06e
      palette = 12=#68a8e4
      palette = 13=#ff5c8f
      palette = 14=#2be4d0
      palette = 15=#fce8c3
    '';

    home.packages = with pkgs; [
      ghostty
    ];
  };
}
