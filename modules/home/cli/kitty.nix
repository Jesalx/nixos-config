{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    kitty.enable = lib.mkEnableOption "enables custom kitty config";
  };
  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      font.name = "MonaspiceNe Nerd Font";
      font.size = 12;
      shellIntegration.enableZshIntegration = true;
      settings =
        {
          enable_audio_bell = false;
          confirm_os_window_close = -1;
        }
        // lib.optionalAttrs pkgs.stdenv.isDarwin {
          background_opacity = "0.8";
          background_blur = 16;
          hide_window_decorations = "titlebar-only";
        };
    };
  };
}
