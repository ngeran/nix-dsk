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

    # Use the structured options provided by the NixOS Telegraf module
    agent = {
      interval = "10s";
      round_interval = true;
      hostname = config.networking.hostName;
      omitHostname = false; # NixOS option is usually camelCase
    };

    inputs = {
      # Use the specific input option for jti_openconfig_telemetry
      jti_openconfig_telemetry = [{
        servers = ["0.0.0.0:50051"];
        sampleFrequency = "2000ms"; # NixOS option is usually camelCase
        sensors = [
          "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
          "/bgp-rib"
        ];
        retryDelay = "1000ms"; # NixOS option is usually camelCase
      }];
    };

    outputs = {
      # Use the specific output option for influxdb_v2
      influxdb_v2 = [{
        urls = ["http://localhost:8086"];
        token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
        organization = "vector";
        bucket = "vector";
      }];
    };

    # Only use extraConfig for truly custom or unsupported Telegraf settings.
    # In this case, we've covered everything with structured options,
    # so we can probably remove extraConfig entirely or leave it empty.
    # extraConfig = ""; # Or simply remove this line if nothing else is needed.
  };

  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];
}
