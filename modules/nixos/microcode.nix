{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ inputs.ucodenix.nixosModules.ucodenix ];
  options.microcode = {
    enable = lib.mkEnableOption "enables AMD microcode updates";
  };

  config = lib.mkIf config.microcode.enable {

    # visit https://github.com/e-tho/ucodenix for configuration details
    services.ucodenix = {
      enable = true;
      cpuModelId = "00A60F12";
    };
  };
}
