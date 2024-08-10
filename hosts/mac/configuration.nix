{ pkgs, ... }:
{
  nix.package = pkgs.nix;
  home.username = "jesal";
  home.homeDirectory = "/Users/jesal";
  imports = [ ./home.nix ];
}
