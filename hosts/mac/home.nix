{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  username = "jesal";
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

  home = {
    username = username;
    homeDirectory = "/home/${username}";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ (nerdfonts.override { fonts = [ "JetBrainsMono" ]; }) ];

  home.sessionVariables = { };

  # Enable home-manager and git
  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
