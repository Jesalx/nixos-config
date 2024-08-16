{
  pkgs,
  lib,
  config,
  userConfig,
  ...
}:
{
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
          "privacy.resistFingerprinting" = true;
          "media.peerconnection.enabled" = false;
          "dom.battery.enabled" = false;
          "browser.tabs.closeWindowWithLastTab" = false;
          "browser.tabs.tabMinWidth" = 50;
          "extensions.screenshots.disabled" = true;
          "extensions.pocket.enabled" = false;
          "signon.rememberSignons" = false;
          "extensions.formautofill.creditCards.enabled" = false;
          "signon.generation.enabled" = false;
          # Add custom search engine for nixpkgs
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        };
        search = {
          force = true;
          default = "Google";
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@nix" ];
            };

            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
          order = [
            "Google"
            "DuckDuckGo"
            "Nix Packages"
          ];
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
