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

      shellAliases = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux {
          # Linux-specific aliases
          nix-test = "${nix-helper-app}/bin/nix-rebuild test default";
          nix-rebuild = "${nix-helper-app}/bin/nix-rebuild switch default";
          nix-update = "${nix-helper-app}/bin/nix-rebuild update default";
          nix-clean = "${nix-helper-app}/bin/nix-rebuild clean default";
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          # macOS-specific aliases
          nix-test = "${nix-helper-app}/bin/nix-rebuild test work";
          nix-rebuild = "${nix-helper-app}/bin/nix-rebuild switch work";
          nix-update = "${nix-helper-app}/bin/nix-rebuild update work";
          nix-clean = "${nix-helper-app}/bin/nix-rebuild clean work";
        })
        {
          # Common aliases for both platforms
          nix-config = "nvim ~/nixos-config";
          vimconfig = "nvim ~/nixos-config/dotfiles/nvim";
        }
      ];
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
