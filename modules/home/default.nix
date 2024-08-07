{ pkgs, lib, ... }:
{
  imports = [
    ./cli/git.nix
    ./cli/kitty.nix
    ./cli/neovim.nix
    ./cli/starship.nix
    ./cli/zsh.nix
    ./gui/theme.nix
    ./gui/wofi.nix
  ];

  git.enable = true;
  lazygit.enable = true;
  kitty.enable = true;
  neovim.enable = true;
  theme.enable = true;
  zsh.enable = true;
  starship.enable = true;
  wofi.enable = true;
}
