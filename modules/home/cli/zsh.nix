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
        nix-test = "${nix-helper-app}/bin/nix-rebuild test";
        nix-rebuild = "${nix-helper-app}/bin/nix-rebuild switch";
        nix-update = "${nix-helper-app}/bin/nix-rebuild update";
        nix-clean = "${nix-helper-app}/bin/nix-rebuild clean";
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
