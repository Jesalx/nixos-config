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
    cpuSerialNumber = lib.mkOption {
      type = lib.types.str;
      description = "CPU serial number for AMD microcode updates";
    };
  };

  config = lib.mkIf config.microcode.enable {

    # visit https://github.com/e-tho/ucodenix for configuration details
    services.ucodenix = {
      enable = true;
      cpuSerialNumber = config.microcode.cpuSerialNumber;
    };
  };
}
