{
  pkgs,
  lib,
  config,
  userConfig,
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
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          # MacOS specific aliases
        })
        {
          # Common aliases for both platforms
          jp-test = "${nix-helper-app}/bin/nix-rebuild test ${userConfig.profile}";
          jp-switch = "${nix-helper-app}/bin/nix-rebuild switch ${userConfig.profile}";
          jp-update = "${nix-helper-app}/bin/nix-rebuild update ${userConfig.profile}";
          jp-clean = "${nix-helper-app}/bin/nix-rebuild clean ${userConfig.profile}";
          nixconfig = "nvim ${home}/nixos-config";
          vimconfig = "nvim ${home}/nixos-config/dotfiles/nvim";
        }
        (lib.mkIf config.development.enable { cat = "bat --paging=never"; })
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
