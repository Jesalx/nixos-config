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

  hyprland.enable = true;
  hyprpaper.enable = true;
  hyprlock.enable = true;
  hypridle.enable = true;
  theme.enable = true;
  wofi.enable = true;
}
