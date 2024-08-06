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
        unzip
        fzf
        fd
        tree-sitter
        cargo
        nil
        lua-language-server
        stylua
        gopls
        alejandra
      ];
    };
  };
}
