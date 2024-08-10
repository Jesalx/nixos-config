{ pkgs, lib, ... }:
{
  imports = [
    ./hyprland.nix
    ./steam.nix
    ./nh.nix
  ];

  hyprland.enable = true;
  steam.enable = true;
  nh.enable = true;
}
