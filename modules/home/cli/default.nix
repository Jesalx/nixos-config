{ pkgs, lib, ... }:
{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./starship.nix
    ./zsh.nix
  ];

  git.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  kitty.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
}
