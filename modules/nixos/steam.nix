{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    steam.enable = lib.mkEnableOption "enables steam";
  };
  config = lib.mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [ protonup ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/jesal/.steam/root/compatibilitytools.d";
    };
  };
}