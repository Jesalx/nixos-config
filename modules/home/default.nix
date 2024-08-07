{ pkgs, lib, ... }:
{
  imports = [
    ./git.nix
    ./kitty.nix
    ./neovim.nix
    ./starship.nix
    ./theme.nix
    ./zsh.nix
  ];

  git.enable = true;
  kitty.enable = true;
  neovim.enable = true;
  theme.enable = true;
  zsh.enable = true;
  starship.enable = true;
}
