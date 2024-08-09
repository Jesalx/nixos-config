{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "patel";
in
{
  imports = [ ../../modules/home/cli/default.nix ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    warn-dirty = false;
  };

  # home-manager = {
  #   backupFileExtension = "backup";
  # };

  home = {
    username = username;
    homeDirectory = "/Users/${username}";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ripgrep
    fd
    fzf
  ];

  home.sessionVariables = { };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
