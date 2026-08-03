{
  lib,
  config,
  ...
}: {
  options.dns = {
    enable = lib.mkEnableOption "enables systemd-resolved with DNS-over-TLS";
  };

  config = lib.mkIf config.dns.enable {
    # The upstream resolver embeds a per-profile identifier, so it lives in an
    # untracked /etc/systemd/resolved.conf.d drop-in rather than here.
    services.resolved = {
      enable = true;

      settings.Resolve = {
        DNSOverTLS = true;
        # Route every lookup to the global resolver, not DHCP-supplied servers.
        Domains = ["~."];
      };
    };

    # Both keys are required: per NetworkManager.conf(5) the `main` setting "has
    # no effect if the main dns plugin is already systemd-resolved", which
    # resolved.nix:224 hardcodes, hence mkForce.
    networking.networkmanager = {
      dns = lib.mkForce "none";
      settings.main.systemd-resolved = false;
    };
  };
}
