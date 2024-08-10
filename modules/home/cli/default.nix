{ pkgs, lib, ... }:
{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./nh.nix
    ./starship.nix
    ./zsh.nix
  ];

  git.enable = true;
  lazygit.enable = true;
  kitty.enable = true;
  neovim.enable = true;
  zsh.enable = true;
  nh.enable = true;
  starship.enable = true;
}
