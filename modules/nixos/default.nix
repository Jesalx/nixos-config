{ pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
    ./steam.nix
  ];
  hyprland.enable = true;
  steam.enable = true;
}
