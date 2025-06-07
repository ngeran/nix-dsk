# /etc/nixos/configuration.nix
{ config, pkgs, lib, ... }:

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
    # Use lib.mkForce to ensure your configuration overrides any default.
    extraConfig = lib.mkForce ''
      # Global agent configuration
      [agent]
        interval = "10s"
        round_interval = true
        hostname = "${config.networking.hostName}" # Identifies the Telegraf host
        omit_hostname = false

      # Juniper JTI OpenConfig Telemetry Input
      [[inputs.jti_openconfig_telemetry]]
        ## List of device addresses (Telegraf listens on these) to collect telemetry from
        servers = ["0.0.0.0:50051"] # Telegraf listens for JTI on this IP/port
        sample_frequency = "2000ms"
        sensors = [
          "/network-instances/network-instance/protocols/protocol/bgp/neighbors",
          "/bgp-rib",
        ]
        retry_delay = "1000ms"

      # InfluxDB 2.x Output
      [[outputs.influxdb_v2]]
        urls = ["http://localhost:8086"]
        token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ=="
        organization = "vector"
        bucket = "vector"
    '';
  };

  # Open the port for Telegraf to receive JTI data
  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];

  # ... rest of your configuration ...
}
