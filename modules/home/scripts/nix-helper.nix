{ pkgs, user }:

pkgs.writeShellApplication {
  name = "nix-rebuild";
  runtimeInputs = with pkgs; [
    git
    nh
  ];
  text = # bash
    ''
      set -euo pipefail
      perform_action() {
        local action=$1
        
        pushd . > /dev/null
        cd /home/${user}/nixos-config
        git add --intent-to-add .
        if [ "$action" = "test" ]; then
          nh os test -H default
        elif [ "$action" = "switch" ]; then
          nh os switch -H default
        elif [ "$action" = "update" ]; then
          nh os switch -u -H default
        elif [ "$action" = "clean" ]; then
          nh clean all --keep-since 15d --keep 15
        else
          echo "Invalid action. Use 'test', 'switch', 'update', or 'clean'."
          exit 1
        fi
        popd > /dev/null
      }
      if [ $# -eq 0 ]; then
        echo "Usage: nix-rebuild-app [test|switch|update|clean]"
        exit 1
      fi
      perform_action "$1"
    '';
}
