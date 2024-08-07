{ pkgs, lib, ... }:
{
  imports = [
    ./theme.nix
    ./wofi.nix
  ];

  theme.enable = true;
  wofi.enable = true;
}
