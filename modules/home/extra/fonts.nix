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
      nerd-fonts.monaspace
      nerd-fonts.jetbrains-mono
      roboto
      inter
    ];
  };
}
