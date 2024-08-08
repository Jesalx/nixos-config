{ pkgs, lib, ... }:
{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./theme.nix
    ./wofi.nix
  ];

  hyprland.enable = false;
  hyprpaper.enable = false;
  theme.enable = true;
  wofi.enable = true;
}
