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
      background-opacity = 0.8
      background-blur-radius = 20
      window-decoration = false
      gtk-titlebar = false
      font-family = Berkeley Mono Variable

      background = 000000
      foreground = ecf0c1
      selection-background = 686f9a
      selection-foreground = ffffff

      palette = 0=#000000
      palette = 1=#e33400
      palette = 2=#5ccc96
      palette = 3=#b3a1e6
      palette = 4=#00a3cc
      palette = 5=#f2ce00
      palette = 6=#7a5ccc
      palette = 7=#686f9a
      palette = 8=#686f9a
      palette = 9=#e33400
      palette = 10=#5ccc96
      palette = 11=#b3a1e6
      palette = 12=#00a3cc
      palette = 13=#f2ce00
      palette = 14=#7a5ccc
      palette = 15=#f0f1ce
    '';
  };
}
