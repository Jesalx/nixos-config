{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  userConfig,
  ...
}:
let
  wallpaper = ../../dotfiles/wallpaper/blackhole.png;
in
{
  imports = [ outputs.homeManagerModules.default ];

  home = {
    username = userConfig.user;
    homeDirectory = "/home/${userConfig.user}";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    kitty-themes
    nautilus
    zathura
    mpv
    discord
    obsidian
  ];

  home.file."Pictures/Wallpaper/wallpaper.png".source = wallpaper;

  home.sessionVariables = { };

  xdg.mimeApps.defaultApplications = {
    "image/*" = [ "firefox.desktop" ];
    "application/pdf" = [ "zathura.desktop" ];
    "video/png" = [ "mpv.desktop" ];
    "video/jpg" = [ "mpv.desktop" ];
    "video/*" = [ "mpv.desktop" ];
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
