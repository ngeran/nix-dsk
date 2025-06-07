# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

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
    extraConfig = ''
      # Global agent configuration
      [agent]
        interval = "10s"
        round_interval = true
        hostname = "${config.networking.hostName}" # Identifies the Telegraf host
        omit_hostname = false

      # Juniper JTI OpenConfig Telemetry Input
      # This is the Telegraf input plugin that listens for JTI data.
      [[inputs.jti_openconfig_telemetry]]
        ## List of device addresses (Telegraf listens on these) to collect telemetry from
        # Telegraf will act as a gRPC server that Juniper devices connect to.
        # Use 0.0.0.0 to listen on all interfaces.
        # The port 50051 is from your cRPD configuration.
        servers = ["0.0.0.0:50051"] # Telegraf listens for JTI on this IP/port
        sample_frequency = "2000ms" # How often Telegraf tells Juniper to send data
        sensors = [
          "/network-instances/network-instance/protocols/protocol/bgp/neighbors",
          "/bgp-rib",
        ]
        retry_delay = "1000ms"

        # Based on your cRPD config `skip-authentication`, you might not need these.
        # If authentication is required on cRPD, uncomment and set:
        # username = "your_telemetry_user"
        # password = "your_telemetry_password"

      # InfluxDB 2.x Output
      # Telegraf will send the collected data to your InfluxDB 2.x instance.
      [[outputs.influxdb_v2]]
        urls = ["http://localhost:8086"] # InfluxDB 2.x default HTTP address
        token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ=="
        organization = "vector"
        bucket = "vector"
        # These settings ensure data is written correctly to InfluxDB 2.x.
        # The database, username, password, and retention_policy from your cRPD doc
        # are for InfluxDB 1.x and are mapped to bucket, organization, and token in InfluxDB 2.x.
    '';
  };

  # Open the port for Telegraf to receive JTI data
  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];
  # ... rest of your configuration ...

}
