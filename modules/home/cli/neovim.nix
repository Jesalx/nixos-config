{
  pkgs,
  lib,
  config,
  ...
}:
let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in
{
  options = {
    neovim.enable = lib.mkEnableOption "enables custom neovim config";
  };
  config = lib.mkIf config.neovim.enable {
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
        nixfmt-rfc-style
        lua-language-server
        stylua
        gopls
        alejandra
      ];
    };

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
