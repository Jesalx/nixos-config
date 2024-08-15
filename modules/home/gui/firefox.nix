{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };
  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
      };
    };
  };
}
