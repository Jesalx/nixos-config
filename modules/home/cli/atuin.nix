{
  lib,
  config,
  pkgs,
  ...
}: let
  atuin = "${config.programs.atuin.package}/bin/atuin";
  dedupScript = pkgs.writeShellScript "atuin-dedup" ''
    # atuin's history subcommands require a session id; generate an ephemeral
    # one since this runs outside an interactive shell.
    export ATUIN_SESSION="$(${atuin} uuid)"
    exec ${atuin} history dedup --before '1 day ago' --dupkeep 1
  '';
in {
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

    # Weekly store-level dedup. Collapses entries sharing command + cwd +
    # hostname to the single most recent copy, leaving the last day untouched.
    # This is DB hygiene only: the Ctrl-R widget already dedups at display time.
    systemd.user.services.atuin-dedup = {
      Unit.Description = "Deduplicate atuin shell history";
      Service = {
        Type = "oneshot";
        ExecStart = "${dedupScript}";
      };
    };
    systemd.user.timers.atuin-dedup = {
      Unit.Description = "Weekly atuin history dedup";
      Timer = {
        OnCalendar = "weekly";
        Persistent = true;
      };
      Install.WantedBy = ["timers.target"];
    };
  };
}
