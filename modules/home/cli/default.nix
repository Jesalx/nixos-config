{ pkgs, lib, ... }:
{
  imports = [
    ./development.nix
    ./ghostty.nix
    ./direnv.nix
    ./git.nix
    ./jujutsu.nix
    ./neovim.nix
    ./ranger.nix
    ./starship.nix
    ./fish.nix
  ];

  development.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  jujutsu.enable = lib.mkDefault true;
  ghostty.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  ranger.enable = lib.mkDefault true;
  fish.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
}
