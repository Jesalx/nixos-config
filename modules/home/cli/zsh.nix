{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.home.username;
  nix-rebuild-app = pkgs.writeShellApplication {
    name = "nix-rebuild";
    runtimeInputs = with pkgs; [ git ];
    text = # bash
      ''
        set -euo pipefail

        perform_rebuild() {
          local action=$1
          
          pushd . > /dev/null

          cd /home/${user}/nixos-config

          git add --intent-to-add .

          if [ "$action" = "test" ]; then
            sudo nixos-rebuild test --flake .#default
          elif [ "$action" = "switch" ]; then
            sudo nixos-rebuild switch --flake .#default
          else
            echo "Invalid action. Use 'test' or 'switch'."
            exit 1
          fi

          popd > /dev/null
        }

        if [ $# -eq 0 ]; then
          echo "Usage: nix-rebuild-app [test|switch]"
          exit 1
        fi

        perform_rebuild "$1"
      '';
  };
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
