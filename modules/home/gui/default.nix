{ pkgs, lib, ... }:
{
  imports = [
    ./hypr/hyprland.nix
    ./hypr/hyprpaper.nix
    ./hypr/hyprlock.nix
    ./hypr/hypridle.nix
    ./theme.nix
    ./firefox.nix
    ./waybar.nix
    ./wofi.nix
  ];

  hyprland.enable = lib.mkDefault true;
  hyprpaper.enable = lib.mkDefault true;
  hyprlock.enable = lib.mkDefault true;
  hypridle.enable = lib.mkDefault true;
  waybar.enable = lib.mkDefault true;
  theme.enable = lib.mkDefault true;
  firefox.enable = lib.mkDefault true;
  wofi.enable = lib.mkDefault true;
}
