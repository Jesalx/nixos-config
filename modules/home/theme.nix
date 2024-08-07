{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    theme.enable = lib.mkEnableOption "enables custom theme";
  };
  config = lib.mkIf config.theme.enable {
    home.pointerCursor = {
      name = "Numix-Cursor-Light";
      package = pkgs.numix-cursor-theme;
      size = 24;
    };

    gtk = {
      enable = true;
      theme.name = "adw-gtk3";
      cursorTheme = {
        name = "Numix-Cursor-Light";
        package = pkgs.numix-cursor-theme;
        size = 24;
      };
      iconTheme.name = "GruvboxPlus";
    };
  };
}
