{
  pkgs,
  lib,
  config,
  ...
}:
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
  };
}
