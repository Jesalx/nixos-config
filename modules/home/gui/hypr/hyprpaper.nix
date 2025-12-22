{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hyprpaper.enable = lib.mkEnableOption "enables custom hyprpaper settings";
  };
  config = lib.mkIf config.hyprpaper.enable {
    services.hyprpaper.enable = true;
    services.hyprpaper.settings = {
      splash = "off";
      ipc = "off";
      preload = "~/Pictures/Wallpaper/wallpaper.png";
      wallpaper = [
        "DP-2,~/Pictures/Wallpaper/wallpaper.png"
        "HDMI-A-1,~/Pictures/Wallpaper/wallpaper.png"
      ];
    };
  };
}
