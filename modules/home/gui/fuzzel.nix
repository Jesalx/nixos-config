{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    fuzzel.enable = lib.mkEnableOption "enables custom fuzzel config";
  };
  config = lib.mkIf config.fuzzel.enable {
    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "ghostty";
          layer = "overlay";
          width = 35;
          lines = 8;
          tabs = 4;
          horizontal-pad = 20;
          vertical-pad = 10;
          inner-pad = 5;
          image-size-ratio = 0.5;
          line-height = 25;
          letter-spacing = 0;
          prompt = "❯ ";
          icon-theme = "Papirus-Dark";
          icons-enabled = true;
          password-character = "*";
          filter-desktop = true;
          no-exit-on-keyboard-focus-loss = false;
        };
        colors = {
          background = "0d0e0dcc";
          text = "e5e0dcff";
          match = "d972ffff";
          selection = "3772ffff";
          selection-text = "0d0e0dff";
          selection-match = "e5e0dcff";
          border = "d972ffff";
        };
        border = {
          width = 2;
          radius = 8;
        };
      };
    };
  };
}

