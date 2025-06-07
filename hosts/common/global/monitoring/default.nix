{ config, pkgs, lib, inputs, ... }:

let
  grafanaDatasources = {
    apiVersion = 1;
    datasources = [
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
in
{
  environment.systemPackages = with pkgs; [
    influxdb2
    influxdb2-cli
    telegraf
    grafana
    prometheus
  ];

  services.influxdb2.enable = true;

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

        prometheus_client = [{
          listen = ":9273";
        }];
      };
    };
  };

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

    provision = {
      enable = true;
      datasources = {
        settings = grafanaDatasources;
      };
    };
  };

  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  networking.firewall.allowedTCPPorts = [
    3000  # Grafana
    8086  # InfluxDB
    50051 # gRPC (Telegraf)
    9090  # Prometheus
    9273  # Telegraf Prometheus exporter
  ];

  environment.etc."keys/grafana-admin-password".source =
    inputs.self + "/secrets/grafana-admin-password";
}
