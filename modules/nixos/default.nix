{ pkgs, lib, ... }:
{
  imports = [ ./hyprland.nix ];
  hyprland.enable = true;
}
