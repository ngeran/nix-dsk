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
  };

  # Open the port for Telegraf to receive JTI data
  networking.firewall.allowedTCPPorts = [
    8086  # InfluxDB 2.x
    50051 # Juniper JTI gRPC (Telegraf listens here)
  ];
  # ... rest of your configuration ...

}
