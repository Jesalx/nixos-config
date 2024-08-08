{ pkgs, lib, ... }:
{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hyprlock.nix
    ./hypr/hypridle.nix
    ./theme.nix
    ./waybar.nix
    ./wofi.nix
  ];

  hyprland.enable = true;
  hyprpaper.enable = true;
  hyprlock.enable = true;
  hypridle.enable = true;
  waybar.enable = true;
  theme.enable = true;
  wofi.enable = true;
}
