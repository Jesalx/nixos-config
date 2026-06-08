{
  lib,
  config,
  ...
}: {
  imports = [
    ./claude.nix
    ./development.nix
    ./go.nix
    ./keyboards.nix
    ./rust.nix
    ./ghostty.nix
    ./direnv.nix
    ./git.nix
    ./jujutsu.nix
    ./neovim.nix
    ./ranger.nix
    ./starship.nix
    ./zsh.nix
    ./tmux.nix
  ];

  claude.enable = lib.mkDefault true;
  development.enable = lib.mkDefault true;
  go.enable = lib.mkDefault true;
  keyboards.enable = lib.mkDefault true;
  rust.enable = lib.mkDefault true;
  git.enable = lib.mkDefault true;
  jujutsu.enable = lib.mkDefault true;
  ghostty.enable = lib.mkDefault true;
  direnv.enable = lib.mkDefault true;
  lazygit.enable = lib.mkDefault true;
  neovim.enable = lib.mkDefault true;
  ranger.enable = lib.mkDefault true;
  zsh.enable = lib.mkDefault true;
  starship.enable = lib.mkDefault true;
  tmux.enable = lib.mkDefault true;

  home.shellAliases =
    {
      cd = "z";
      nixconfig = "nvim ${config.home.homeDirectory}/nixos-config";
      vimconfig = "nvim ${config.home.homeDirectory}/nixos-config/dotfiles/nvim";
      dt = "ssh jesal@deepthought";
      ls = "eza";
      l = "eza -al";
      ll = "eza -al";
      http = "xh";
      https = "xhs";

      # tmux-sessionizer is not packaged in nixpkgs; pin to the go install path
      tms = "${config.home.homeDirectory}/go/bin/tms";
      ts = "${config.home.homeDirectory}/go/bin/tms";
    }
    // lib.optionalAttrs config.development.enable {cat = "bat --paging=never";};
}
