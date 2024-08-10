{ pkgs, ... }:
{
  nix.package = pkgs.nix;
  home.username = "patel";
  home.homeDirectory = "/Users/patel";
  imports = [ ./home.nix ];
}
