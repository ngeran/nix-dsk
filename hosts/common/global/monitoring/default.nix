# /etc/nixos/modules/monitoring.nix
{ config, pkgs, lib, ... }:

{
  environment.systemPackages = with pkgs; [
    influxdb2
    influxdb2-cli
    telegraf
    grafana
    prometheus
  ];

  # --- InfluxDB 2.x Configuration ---
  services.influxdb2 = {
    enable = true;
  };

  # --- Telegraf Configuration ---
  services.telegraf = {
    enable = true;
    extraConfig = { # This is the working set-based extraConfig
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

      prometheus_client = [{
        listen = ":9273";
      }];
    };
  };

  # --- Prometheus Configuration ---
  services.prometheus = {
    enable = true;
    port = 9090;

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [ { targets = [ "localhost:9090" ]; } ];
      }
      {
        job_name = "telegraf";
        static_configs = [ { targets = [ "localhost:9273" ]; } ];
      }
      {
        job_name = "influxdb";
        static_configs = [ { targets = [ "localhost:8086" ]; } ];
        metrics_path = "/metrics";
      }
    ];
  };

  # --- Grafana Configuration ---
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
        # Password is handled by systemd Environment variable and secret file
      };
    };

    # Provisioning Data Sources
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

  # >>> FIX HERE: Move systemd.services.grafana out of services.grafana <<<
  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  networking.firewall.allowedTCPPorts = [
    3000
    8086
    50051
    9090
    9273
  ];

  # The secret source should ideally remain in configuration.nix or a module
  # that directly "sees" `inputs.self`. If `monitoring.nix` is *part* of your
  # flake (e.g., in `specialArgs`), it might work here.
  # If you get an error about `inputs.self` not existing, move this back to
  # your main `configuration.nix` or ensure `inputs` is passed correctly.
  environment.etc."keys/grafana-admin-password".source =
    config.nixpkgs.inputs.self + "/secrets/grafana-admin-password";
}
