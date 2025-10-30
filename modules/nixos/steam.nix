{
  pkgs,
  lib,
  config,
  userConfig,
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

    environment.systemPackages = with pkgs; [
      protonup-ng
      # lunar-client
    ];

    environment.sessionVariables = {
      STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${userConfig.user}/.steam/root/compatibilitytools.d";
    };
  };
}
