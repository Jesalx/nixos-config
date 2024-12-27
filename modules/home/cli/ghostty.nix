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
      theme = Adventure
      background = 000000
      background-opacity = 0.8
      background-blur-radius = 20
      window-decoration = false
      gtk-titlebar = false
    '';
  };
}
