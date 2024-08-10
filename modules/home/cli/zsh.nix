{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.home.username;
  nix-helper-app = import ../scripts/nix-helper.nix { inherit pkgs user; };
in
{
  options = {
    zsh.enable = lib.mkEnableOption "enables custom zsh config";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        nix-test = "${nix-helper-app}/bin/nix-rebuild test default";
        nix-rebuild = "${nix-helper-app}/bin/nix-rebuild switch default";
        nix-update = "${nix-helper-app}/bin/nix-rebuild update default";
        nix-clean = "${nix-helper-app}/bin/nix-rebuild clean default";
        nix-config = "nvim /home/${user}/nixos-config/";
      };
    };
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
