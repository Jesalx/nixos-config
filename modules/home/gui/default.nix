{ pkgs, lib, ... }:
{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hyprlock.nix
    ./hypr/hypridle.nix
    ./theme.nix
    ./wofi.nix
  ];

  hyprland.enable = false;
  hyprpaper.enable = false;
  hyprlock.enable = false;
  hypridle.enable = false;
  theme.enable = true;
  wofi.enable = true;
}
