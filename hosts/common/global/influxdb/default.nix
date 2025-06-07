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

    # The 'config' option is usually where you provide the structured configuration
    # that the module then serializes into a TOML file for Telegraf.
    # This is an attribute set.
    config = {
      # Global agent configuration
      agent = {
        interval = "10s";
        round_interval = true;
        hostname = config.networking.hostName;
        omit_hostname = false; # Keep this as snake_case as it maps directly to Telegraf's TOML
      };

      # Juniper JTI OpenConfig Telemetry Input
      # This is a list of input plugin configurations.
      inputs = {
        jti_openconfig_telemetry = [{
          servers = ["0.0.0.0:50051"];
          sample_frequency = "2000ms"; # Keep as snake_case for TOML
          sensors = [
            "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
            "/bgp-rib"
          ];
          retry_delay = "1000ms"; # Keep as snake_case for TOML
        }];
      };

      # InfluxDB 2.x Output
      # This is a list of output plugin configurations.
      outputs = {
        influxdb_v2 = [{
          urls = ["http://localhost:8086"];
          token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
          organization = "vector";
          bucket = "vector";
        }];
      };
    };
    # No extraConfig here, as 'config' handles everything.
  };

  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];

  # ... rest of your configuration ...
}
