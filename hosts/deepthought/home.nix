{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  userConfig,
  ...
}:
{
  imports = [ outputs.homeManagerModules ];

  home = {
    username = userConfig.user;
    homeDirectory = "/home/${userConfig.user}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [ ];

  home.sessionVariables = { };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
