{ pkgs, ... }:

{
  config = {
    home.pointerCursor = {
        name = "Numix-Cursor-Light";
        package = pkgs.numix-cursor-theme;
        size = 40;
    };

    gtk = {
        enable = true;
        theme.name = "adw-gtk3";
        cursorTheme = {
        name = "Numix-Cursor-Light";
        package = pkgs.numix-cursor-theme;
        size = 40;
        };
        iconTheme.name = "GruvboxPlus";
    };
  };
}
