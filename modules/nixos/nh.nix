{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = "jesal";
in
{
  options = {
    nh.enable = lib.mkEnableOption "enables nix-helper";
  };
  config = lib.mkIf config.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 15 --keep 10";
      flake = "/home/${user}/nixos-config";
    };
  };
}
