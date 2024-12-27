{ pkgs, lib, ... }:
{
  imports = [
    ./development.nix
    ./ghostty.nix
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./ranger.nix
    ./starship.nix
    ./zsh.nix
  ];

  development.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  ghostty.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  kitty.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  ranger.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
}
