{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hyprland.nix
    ./steam.nix
    ./nh.nix
    ./microcode.nix
    ./dns.nix
  ];

  hyprland.enable = lib.mkDefault true;
  steam.enable = lib.mkDefault true;
  nh.enable = lib.mkDefault true;
  microcode.enable = lib.mkDefault false;
  dns.enable = lib.mkDefault true;
}
