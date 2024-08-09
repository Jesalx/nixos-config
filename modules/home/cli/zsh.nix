{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.home.username;
  nix-rebuild-app = import ../scripts/rebuild.nix { inherit pkgs user; };
in
{
  options = {
    zsh.enable = lib.mkEnableOption "enables custom zsh config";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        nix-test = "${nix-rebuild-app}/bin/nix-rebuild test";
        nix-rebuild = "${nix-rebuild-app}/bin/nix-rebuild switch";
        nix-update = "sudo nix flake update /home/${user}/nixos-config";
        nix-config = "nvim /home/${user}/nixos-config/";
        nix-gc = "sudo nix-collect-garbage --delete-older-than 30d";
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
