{
  pkgs,
  lib,
  config,
  ...
}:
let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in
{
  options = {
    waybar.enable = lib.mkEnableOption "enables waybar";
  };
  config = lib.mkIf config.waybar.enable {
    programs.waybar.enable = true;
    xdg.configFile.waybar.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
  };
}
