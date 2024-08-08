{ pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
    ./theme.nix
    ./wofi.nix
  ];

  hyprland.enable = false;
  theme.enable = true;
  wofi.enable = true;
}
