{ pkgs, user }:

pkgs.writeShellApplication {
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
}
