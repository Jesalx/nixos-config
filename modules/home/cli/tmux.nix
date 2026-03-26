{
  lib,
  config,
  ...
}: let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in {
  options = {
    tmux.enable = lib.mkEnableOption "enables tmux config";
  };
  config = lib.mkIf config.tmux.enable {
    home.file.".tmux.conf".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/tmux/.tmux.conf";
  };
}
