{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}:
let
  user = config.home.username;
  home = config.home.homeDirectory;
  nix-helper-app = import ../scripts/nix-helper.nix { inherit pkgs user; };
in
{
  options = {
    fish.enable = lib.mkEnableOption "enables custom fish config";
  };
  config = lib.mkIf config.fish.enable {
    programs.fish = {
      enable = true;

      # Custom keybindings for fzf-fish
      interactiveShellInit = ''
        # Configure fzf.fish keybindings
        # Ctrl+F for directory, Ctrl+R for history, Ctrl+T for variables  
        fzf_configure_bindings --directory=\cf --history=\cr --variables=\ct
      '';

      shellAliases = lib.mkMerge [
        (lib.mkIf pkgs.stdenv.isLinux {
          # Linux specific aliases
        })
        (lib.mkIf pkgs.stdenv.isDarwin {
          # MacOS specific aliases
        })
        {
          # Common aliases for both platforms
          jp-test = "${nix-helper-app}/bin/nix-rebuild test ${userConfig.profile}";
          jp-switch = "${nix-helper-app}/bin/nix-rebuild switch ${userConfig.profile}";
          jp-update = "${nix-helper-app}/bin/nix-rebuild update ${userConfig.profile}";
          jp-clean = "${nix-helper-app}/bin/nix-rebuild clean ${userConfig.profile}";
          nixconfig = "nvim ${home}/nixos-config";
          vimconfig = "nvim ${home}/nixos-config/dotfiles/nvim";
          dt = "ssh jesal@deepthought";
        }
        (lib.mkIf config.development.enable { cat = "bat --paging=never"; })
      ];

      shellAbbrs = {
        gg = "jj";
        g = "jj";
        j = "jj";
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    home.packages = with pkgs; [
      fishPlugins.fzf-fish
    ];
  };
}
