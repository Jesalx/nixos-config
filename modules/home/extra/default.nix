{ pkgs, lib, ... }:
{
  imports = [ ./fonts.nix ];

  fonts.enable = lib.mkDefault true;
}
