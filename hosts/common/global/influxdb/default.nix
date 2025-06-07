# /etc/nixos/configuration.nix

{ config, pkgs, lib, ... }: # Ensure 'lib' is here

{
  environment.systemPackages = with pkgs; [
    influxdb2
    influxdb2-cli
    telegraf
  ];

  services.influxdb2 = {
    enable = true;
  };

  services.telegraf = {
    enable = true;

    # Use a combined approach:
    # 1. Use structured options for inputs and outputs (as these are well-defined NixOS options).
    # 2. Use extraConfig for agent settings and any other sections that don't have direct NixOS options.
    inputs = {
      jti_openconfig_telemetry = [{
        servers = ["0.0.0.0:50051"];
        sampleFrequency = "2000ms";
        sensors = [
          "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
          "/bgp-rib"
        ];
        retryDelay = "1000ms";
      }];
    };

    outputs = {
      influxdb_v2 = [{
        urls = ["http://localhost:8086"];
        token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
        organization = "vector";
        bucket = "vector";
      }];
    };

    # Re-introduce extraConfig for the 'agent' section.
    # Use lib.mkForce to ensure this string content takes precedence
    # for the parts of the configuration that aren't covered by structured options.
    extraConfig = lib.mkForce ''
      # Global agent configuration
      [agent]
        interval = "10s"
        round_interval = true
        hostname = "${config.networking.hostName}"
        omit_hostname = false
    '';
  };

  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];
}
