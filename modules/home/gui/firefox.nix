{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}: {
  options = {
    firefox.enable = lib.mkEnableOption "enables firefox";
  };
  config = lib.mkIf config.firefox.enable {
    programs.firefox = {
      enable = true;
      profiles."${userConfig.user}" = {
        id = 0;
        name = userConfig.user;
        isDefault = true;
        settings = {
          "general.autoScroll" = true;
          "media.peerconnection.enabled" = false;
          "dom.battery.enabled" = false;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.tabs.tabMinWidth" = 50;
          "extensions.screenshots.disabled" = true;
          "extensions.pocket.enabled" = false;
          "signon.rememberSignons" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.generation.enabled" = false;
          "browser.uidensity" = 1;
        };
      };
      policies = {
        DisableTelemetry = true;
        DisableFirefoxStudies = true;
        DisablePocket = true;
      };
    };
  };
}
