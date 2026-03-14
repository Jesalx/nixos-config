{
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
    home.file = {
      ".claude/CLAUDE.md".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/CLAUDE.md";
      ".claude/agents".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/agents";
      ".claude/rules".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/rules";
      ".claude/skills".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/.claude/skills";
    };
  };
}
