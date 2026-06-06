{
  pkgs,
  lib,
  config,
  ...
}: let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in {
  options = {
    zsh.enable = lib.mkEnableOption "enables custom zsh config";
  };
  config = lib.mkIf config.zsh.enable {
    programs = {
      # The real config lives in the repo and is shared verbatim with non-nix
      # machines (dotfiles/zsh/.zshrc). As with neovim and tmux, that repo file
      # is the single source of truth; the difference is Home Manager owns
      # ~/.zshrc, so it sources the live file rather than symlinking it. Plugins
      # are managed inside that file (git clone), not by Home Manager, so the
      # interactive setup is identical everywhere.
      zsh = {
        enable = true;
        initContent = ''
          source "${dotfiles}/zsh/.zshrc"
        '';
      };

      # Provide the binaries, but let the shared .zshrc set up shell integration
      # so it stays portable; disable Home Manager's generated init to avoid
      # double-loading.
      fzf = {
        enable = true;
        enableZshIntegration = false;
      };
      zoxide = {
        enable = true;
        enableZshIntegration = false;
      };
      starship.enableZshIntegration = false;
    };

    home.packages = with pkgs; [
      yazi
    ];
  };
}
