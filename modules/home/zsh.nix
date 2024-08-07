{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    zsh.enable = lib.mkEnableOption "enables custom zsh config";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      shellAliases = {
        nix-test = "sudo nixos-rebuild test --flake /home/jesal/nixos-config#default";
        nix-rebuild = "sudo nixos-rebuild switch --flake /home/jesal/nixos-config#default";
        nix-update = "sudo nix flake update /home/jesal/nixos-config";
        nix-config = "nvim /home/jesal/nixos-config/";
        nix-gc = "sudo nix-collect-garbage -d";
      };
    };
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
    };
  };
}
