{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    ranger.enable = lib.mkEnableOption "enables ranger";
  };
  config = lib.mkIf config.ranger.enable {
    programs.ranger = {
      enable = true;
    };
  };
}
