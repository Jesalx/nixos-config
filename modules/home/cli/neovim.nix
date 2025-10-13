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

      withRuby = true;
      withNodeJs = true;
      withPython3 = true;

      extraPackages = with pkgs; [
        git
        gcc
        gnumake
        unzip
        fzf
        wget
        curl
        ripgrep
        rust-analyzer
        fd
        tree-sitter
        rustc
        cargo
        gcc
        nil
        nixfmt-rfc-style
        lua
        lua-language-server
        stylua
        gopls
        alejandra
        zls
      ];
    };

    xdg.configFile.nvim.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/nvim";

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };
}
