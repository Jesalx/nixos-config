{
  pkgs,
  lib,
  config,
  ...
}: let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in {
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

      withRuby = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        tree-sitter
        nil
        lua
        lua-language-server
        stylua
        mermaid-cli
      ];
    };

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
