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
  imports = [outputs.homeManagerModules];

  home = {
    username = userConfig.user;
    homeDirectory = "/home/${userConfig.user}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.packages = with pkgs; [
    nautilus
    zathura
    mpv
    discord
    slack
    obsidian
    pandoc
    helium
  ];

  home.sessionPath = ["$HOME/.cargo/bin"];

  home.sessionVariables = {};

  xdg.mimeApps.enable = true;
  xdg.mimeApps.defaultApplications = {
    "x-scheme-handler/http" = ["Helium.desktop"];
    "x-scheme-handler/https" = ["Helium.desktop"];
    "text/html" = ["Helium.desktop"];
    "image/*" = ["firefox.desktop"];
    "application/pdf" = ["zathura.desktop"];
    "video/png" = ["mpv.desktop"];
    "video/jpg" = ["mpv.desktop"];
    "video/*" = ["mpv.desktop"];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
