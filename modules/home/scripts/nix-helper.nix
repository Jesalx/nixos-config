{ pkgs, user }:
pkgs.writeShellApplication {
  name = "nix-rebuild";
  runtimeInputs = with pkgs; [
    git
    nh
    home-manager
  ];
  text = # bash
    ''
      set -euo pipefail

      detect_os() {
        case "$OSTYPE" in
          darwin*) echo "macos" ;;
          linux*)  echo "linux" ;;
          *)       echo "unknown" ;;
        esac
      }

      get_config_path() {
        local os="$1"
        if [ "$os" = "macos" ]; then
          echo "/Users/${user}/nixos-config"
        else
          echo "/home/${user}/nixos-config"
        fi
      }

      perform_action() {
        local action="$1"
        local config="$2"
        local os
        os=$(detect_os)
        local config_path
        config_path=$(get_config_path "$os")
        
        pushd . > /dev/null || exit
        cd "$config_path" || exit

        git add --intent-to-add .

        if [ "$os" = "macos" ]; then
          # macOS specific commands
          if [ "$action" = "test" ]; then
            home-manager build -b backup --flake "$config_path#$config"
          elif [ "$action" = "switch" ]; then
            home-manager switch -b backup --flake "$config_path#$config"
          elif [ "$action" = "update" ]; then
            nix flake update
            home-manager switch -b backup --flake "$config_path#$config"
          elif [ "$action" = "clean" ]; then
            nix-collect-garbage -d
          else
            echo "Invalid action for macOS. Use 'test', 'switch', 'update', or 'clean'."
            exit 1
          fi
        elif [ "$os" = "linux" ]; then
          # Linux specific commands (using nh as in your original script)
          if [ "$action" = "test" ]; then
            nh os test -H "$config"
          elif [ "$action" = "switch" ]; then
            nh os switch -H "$config"
          elif [ "$action" = "update" ]; then
            nh os switch -u -H "$config"
          elif [ "$action" = "clean" ]; then
            nh clean all --keep-since 15d --keep 15
          else
            echo "Invalid action for Linux. Use 'test', 'switch', 'update', or 'clean'."
            exit 1
          fi
        else
          echo "Unsupported operating system."
          exit 1
        fi

        popd > /dev/null || exit
      }

      if [ $# -lt 2 ]; then
        echo "Usage: nix-rebuild-app [test|switch|update|clean] [configuration]"
        exit 1
      fi

      perform_action "$1" "$2"
    '';
}
