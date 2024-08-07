{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
  wallpaper = ../../dotfiles/wallpaper/blackhole.png;
in
{
  imports = [ outputs.homeManagerModules.default ];

  nixpkgs = {
    overlays = [ ];
    config = {
      allowUnfree = true;
    };
  };

  home = {
    username = "jesal";
    homeDirectory = "/home/jesal";
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    kitty-themes
    zathura
    mpv
    discord
    obsidian

    rustup
    nodejs_22
    pyenv
    python3
    go
    gcc
    gnumake
    unzip
    wget
    curl
    ripgrep
    fd
    fzf
    alejandra
  ];

  home.file."Pictures/Wallpaper/wallpaper.png".source = wallpaper;

  xdg.configFile = {
    waybar.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/waybar";
    hypr.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/hypr";
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";
  };

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

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
