{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  user = "jesal";
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
    username = user;
    homeDirectory = "/Users/${user}";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ripgrep
    fd
    fzf
  ];

  home.sessionVariables = { };

  programs.home-manager.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
