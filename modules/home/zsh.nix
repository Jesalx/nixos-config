{ ... }:

{
  config = {
    programs.zsh = {
        enable = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        shellAliases = {
        nix-rebuild = "sudo nixos-rebuild switch --flake /home/jesal/nixos-config#default";
        ".." = "cd ..";
        };
    };
    
    programs.starship = {
        enable = true;
    };
  };
}
