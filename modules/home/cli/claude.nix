{
  pkgs,
  lib,
  config,
  ...
}: let
  dotfiles = config.home.homeDirectory + "/nixos-config/dotfiles";
in {
  options = {
    claude.enable = lib.mkEnableOption "enables claude code config";
  };
  config = lib.mkIf config.claude.enable {
    home.packages = with pkgs; [
      claude-code
    ];

    home.file = {
      ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/CLAUDE.md";
      ".claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/agents";
      ".claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/rules";
      ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/skills";
      ".claude/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/settings.json";
      ".claude/statusline-command.sh".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/claude/statusline-command.sh";
    };
  };
}
