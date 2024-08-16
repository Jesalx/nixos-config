{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    fonts.enable = lib.mkEnableOption "enables fonts";
  };
  config = lib.mkIf config.fonts.enable {
    fonts.fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [
          "MonaspiceNe Nerd Font"
          "JetBrainsMono Nerd Font"
        ];
        sansSerif = [
          "Inter"
          "Roboto"
        ];
      };
    };

    home.packages = with pkgs; [
      (nerdfonts.override {
        fonts = [
          "Monaspace" # Actual nerd font is referred to as "Monaspice"
          "JetBrainsMono"
        ];
      })
      roboto
      inter
    ];
  };
}
