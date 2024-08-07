{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  imports = [
    ../../modules/home/zsh.nix
    ../../modules/home/neovim.nix
    ../../modules/home/kitty.nix
    ../../modules/home/theme.nix
    ../../modules/home/git.nix
  ];

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
    lazygit
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

  xdg.configFile = {
    waybar.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/waybar";
    wofi.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/wofi";
    hypr.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/hypr";
    nvim.source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixos-config/dotfiles/nvim";
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
