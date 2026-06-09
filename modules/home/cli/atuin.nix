{
  lib,
  config,
  ...
}: {
  options = {
    atuin.enable = lib.mkEnableOption "enables atuin shell history";
  };
  config = lib.mkIf config.atuin.enable {
    programs.atuin = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        update_check = false;
        search_mode = "fuzzy";
      };
    };
  };
}
