{ pkgs, lib, ... }:
{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hyprlock.nix
    ./theme.nix
    ./wofi.nix
  ];

  hyprland.enable = false;
  hyprpaper.enable = false;
  hyprlock.enable = false;
  theme.enable = true;
  wofi.enable = true;
}
