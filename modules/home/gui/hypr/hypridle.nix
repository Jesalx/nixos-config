{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    hypridle.enable = lib.mkEnableOption "enables custom hypridle settings";
  };
  config = lib.mkIf config.hypridle.enable {
    services.hypridle.enable = true;
    services.hypridle.settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
      };

      listener = [
        {
          timeout = 240; # 4 min
          on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
        }

        {
          timeout = 480; # 8 min
          on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
          on-resume = "hyprctl dispatch dpms on"; # screen on when activity is detected after timeout has fired.
        }
      ];
    };
  };
}
