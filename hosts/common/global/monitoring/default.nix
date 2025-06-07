# /etc/nixos/modules/monitoring.nix
# This module defines the monitoring stack services (InfluxDB, Telegraf, Prometheus, Grafana).

{ config, pkgs, lib, ... }:

{
  # 1. Define all necessary packages for the monitoring stack
  environment.systemPackages = with pkgs; [
    influxdb2
    influxdb2-cli
    telegraf
    grafana
    prometheus
  ];

  # 2. InfluxDB 2.x Configuration
  services.influxdb2 = {
    enable = true;
  };

  # 3. Telegraf Configuration
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
          servers = [ "0.0.0.0:50051" ];
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
          urls = [ "http://localhost:8086" ];
          token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
          organization = "vector";
          bucket = "vector";
        }];
      };
      prometheus_client = [{
        listen = ":9273";
      }];
    };
  };

  # 4. Prometheus Configuration
  services.prometheus = {
    enable = true;
    port = 9090;
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [{ targets = [ "localhost:9090" ]; }];
      }
      {
        job_name = "telegraf";
        static_configs = [{ targets = [ "localhost:9273" ]; }];
      }
      {
        job_name = "influxdb";
        static_configs = [{ targets = [ "localhost:8086" ]; }];
        metrics_path = "/metrics";
      }
    ];
  };

  # 5. Grafana Configuration
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "vector.ngeran";
      };
      security = {
        admin_user = "admin";
      };
    };

    # ✅ Correct structure: list of datasources, no arbitrary nesting
    provision.datasources = [
      {
        name = "InfluxDB-Juniper-Telemetry";
        type = "influxdb";
        access = "proxy";
        url = "http://localhost:8086";
        isDefault = true;
        jsonData = {
          defaultBucket = "vector";
          organization = "vector";
          version = "Flux";
          tlsSkipVerify = false;
        };
        secureJsonData = {
          token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
        };
      }
      {
        name = "Prometheus-Metrics";
        type = "prometheus";
        access = "proxy";
        url = "http://localhost:9090";
        isDefault = false;
      }
    ];
  };

  # 6. Systemd service configuration for Grafana's admin password
  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  # 7. Firewall Configuration
  networking.firewall.allowedTCPPorts = [
    3000  # Grafana
    8086  # InfluxDB
    50051 # Telegraf gRPC input
    9090  # Prometheus
    9273  # Telegraf Prometheus exporter
  ];

  # 8. Secret Management for Grafana Admin Password
  environment.etc."keys/grafana-admin-password".source =
    config.nixpkgs.inputs.self + "/secrets/grafana-admin-password";
}
