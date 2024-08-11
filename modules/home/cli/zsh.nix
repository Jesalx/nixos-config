{
  pkgs,
  lib,
  config,
  ...
}:
let
  user = config.home.username;
  home = config.home.homeDirectory;
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
          # Linux specific aliases
          jp-test = "${nix-helper-app}/bin/nix-rebuild test default";
          jp-switch = "${nix-helper-app}/bin/nix-rebuild switch default";
          jp-update = "${nix-helper-app}/bin/nix-rebuild update default";
          jp-clean = "${nix-helper-app}/bin/nix-rebuild clean default";
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          # MacOS specific aliases
          jp-test = "${nix-helper-app}/bin/nix-rebuild test";
          jp-switch = "${nix-helper-app}/bin/nix-rebuild switch";
          jp-update = "${nix-helper-app}/bin/nix-rebuild update";
          jp-clean = "${nix-helper-app}/bin/nix-rebuild clean";
        })
        {
          # Common aliases for both platforms
          nixconfig = "nvim ${home}/nixos-config";
          vimconfig = "nvim ${home}/nixos-config/dotfiles/nvim";
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
