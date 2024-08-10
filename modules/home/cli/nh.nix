{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.home.username;
in
{
  options = {
    nh.enable = lib.mkEnableOption "enables nix-helper";
  };
  config = lib.mkIf config.nh.enable {
    home.packages = with pkgs; [ nh ];
    home.sessionVariables = {
      FLAKE = "/home/${user}/nixos-config";
    };
  };
}
