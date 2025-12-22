{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}: {
  options = {
    nh.enable = lib.mkEnableOption "enables nix-helper";
  };
  config = lib.mkIf config.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 10";
      flake = "/home/${userConfig.user}/nixos-config";
    };
  };
}
