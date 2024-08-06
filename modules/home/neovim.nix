{ pkgs, ... }:

{
  config = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      
      extraPackages = with pkgs; [
        tree-sitter
        nil
        lua-language-server
        stylua
        gopls
      ];
    };
  };
}
