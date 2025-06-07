# /etc/nixos/modules/monitoring.nix
{ config, pkgs, lib, ... }:

{
  # Ensure all necessary packages are installed
  environment.systemPackages = with pkgs; [
    influxdb2
    influxdb2-cli
    telegraf
    grafana # Add grafana to the package list
    prometheus
  ];

  # --- InfluxDB 2.x Configuration ---
  services.influxdb2 = {
    enable = true;
    # dataDir = "/var/lib/influxdb2"; # Optional: Uncomment to specify data directory
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
          servers = ["0.0.0.0:50051"]; # Telegraf listens for JTI on this IP/port
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
          organization = "vector"; # IMPORTANT: Replace with YOUR organization
          bucket = "vector";       # IMPORTANT: Replace with YOUR bucket
        }];
      };

      # Telegraf's own metrics for Prometheus
      prometheus_client = [{
        listen = ":9273"; # Telegraf will serve Prometheus metrics on this port
      }];
    };
  };

  # --- Prometheus Configuration ---
  services.prometheus = {
    enable = true;
    port = 9090; # Web UI will be available on http://localhost:9090

    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [ "localhost:9090" ];
          }
        ];
      }
      {
        job_name = "telegraf";
        static_configs = [
          {
            targets = [ "localhost:9273" ]; # Scrape Telegraf's metrics
          }
        ];
      }
      {
        job_name = "influxdb";
        static_configs = [
          {
            targets = [ "localhost:8086" ]; # Scrape InfluxDB's metrics
          }
        ];
        metrics_path = "/metrics";
      }
    ];
  };

  # --- Grafana Configuration ---
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1"; # Keep local if you intend to proxy it later, or "0.0.0.0" for wider access
        http_port = 3000;
        domain = "vector.ngeran";
      };
      security = {
        admin_user = "admin";
        # Password is handled by systemd Environment variable and secret file
      };
    };

    # Inject the password at runtime via environment variable
    systemd.services.grafana.serviceConfig.Environment = [
      "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
    ];

    # Provisioning Data Sources
    provision.datasources = [
      {
        name = "InfluxDB-Juniper-Telemetry";
        type = "influxdb";
        access = "proxy";
        url = "http://localhost:8086";
        isDefault = true;
        jsonData = {
          defaultBucket = "vector"; # Your InfluxDB 2.x bucket
          organization = "vector";   # Your InfluxDB 2.x organization
          version = "Flux";
          tlsSkipVerify = false;
        };
        secureJsonData = {
          # This token should ideally be a read-only token for Grafana
          token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ=="; # IMPORTANT: Replace with YOUR token
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

    # Optional: Dashboards provisioning if you have JSON dashboards
    # provision.dashboards.settings = {
    #   providers = [{
    #     name = "default";
    #     orgId = 1;
    #     folder = "";
    #     type = "file";
    #     disableDelete = false;
    #     editable = true;
    #     options.path = "/etc/grafana/dashboards"; # Or an absolute path to your dashboard JSON files
    #   }];
    # };
  };

  # --- Firewall Configuration ---
  networking.firewall.allowedTCPPorts = [
    3000  # Grafana UI
    8086  # InfluxDB 2.x HTTP API
    50051 # Juniper JTI gRPC (Telegraf listens here)
    9090  # Prometheus HTTP UI
    9273  # Telegraf's Prometheus client output
  ];

  # If you are using a flake for secrets and `inputs.self` is not available
  # in this module, you might need to adjust the secret path for Grafana
  # or pass it in. If this module is part of your main flake output,
  # it should be fine. Otherwise, consider an absolute path or a different secret management.
  # For now, assuming it works as before:
  environment.etc."keys/grafana-admin-password".source =
    config.nixpkgs.inputs.self + "/secrets/grafana-admin-password"; # Adjust path if self is not available here
}
