# /etc/nixos/configuration.nix

{ config, pkgs, lib, ... }: # Ensure 'lib' is included

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

    extraConfig = {
      agent = {
        interval = "10s";
        round_interval = true;
        hostname = config.networking.hostName;
        omit_hostname = false;
      };

      inputs = {
        jti_openconfig_telemetry = [{
          servers = ["0.0.0.0:50051"];
          sample_frequency = "2000ms";
          sensors = [
            "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
            "/bgp-rib"
          ];
          retry_delay = "1000ms";
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
    };
  };

  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];

  # ... any other configuration ...
}
