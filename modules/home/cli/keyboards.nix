{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    keyboards.enable = lib.mkEnableOption "enables keyboard flashing tools";
  };
  config = lib.mkIf config.keyboards.enable {
    home.packages = with pkgs; [
      qmk
      via
    ];
  };
}
