{ ... }:

{
  config = {
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        shellAliases = {
          nix-rebuild = "sudo nixos-rebuild switch --flake /home/jesal/nixos-config#default";
          nix-update = "sudo nix flake update /home/jesal/nixos-config";
        };
    };
    
    programs.starship = {
        enable = true;
    };
  };
}
