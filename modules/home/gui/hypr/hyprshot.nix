{
  pkgs,
  lib,
  config,
  ...
}: {
  options = {
    hyprshot.enable = lib.mkEnableOption "enables hyprshot screenshot tool";
  };
  config = lib.mkIf config.hyprshot.enable {
    home.packages = with pkgs; [
      hyprshot
    ];
  };
}
