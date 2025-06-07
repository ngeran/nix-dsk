# /etc/nixos/modules/monitoring.nix
# This module defines the monitoring stack services (InfluxDB, Telegraf, Prometheus, Grafana).

{ config, pkgs, lib, ... }: # Ensure 'lib' is included for mkForce if needed, and 'config' for hostname etc.

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
    # Optional: Uncomment to change the data directory if needed.
    # dataDir = "/var/lib/influxdb2";
  };

  # 3. Telegraf Configuration
  # This uses the 'extraConfig' option, which expects a Nix attribute set
  # that directly mirrors the TOML structure of the Telegraf configuration file.
  services.telegraf = {
    enable = true;
    extraConfig = { # This entire block is a Nix attribute set that will be converted to TOML
      # Global agent configuration section [agent]
      agent = {
        interval = "10s";
        round_interval = true;
        hostname = config.networking.hostName; # Uses your system's hostname
        omit_hostname = false;
      };

      # Juniper JTI OpenConfig Telemetry Input plugin [[inputs.jti_openconfig_telemetry]]
      # Telegraf listens for gRPC streams from Juniper devices.
      inputs = {
        jti_openconfig_telemetry = [{ # This is a list because you can define multiple instances of the same input
          servers = ["0.0.0.0:50051"]; # Telegraf listens on this IP and port for JTI data
          sample_frequency = "2000ms"; # How often Telegraf requests data (2 seconds)
          sensors = [ # Telemetry paths to subscribe to
            "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
            "/bgp-rib"
          ];
          retry_delay = "1000ms";
          # If your cRPD requires authentication, uncomment these and fill in:
          # username = "your_telemetry_user";
          # password = "your_telemetry_password";
        }];
      };

      # InfluxDB 2.x Output plugin [[outputs.influxdb_v2]]
      # Telegraf sends collected data to your InfluxDB instance.
      outputs = {
        influxdb_v2 = [{ # This is a list because you can define multiple outputs
          urls = ["http://localhost:8086"]; # InfluxDB 2.x default HTTP address
          # !!! IMPORTANT !!! Replace with the token generated from 'influx setup'
          token = "abVGyimvFALQqA6H1bvWsvI1jyBs9HA5fmtge1KeMWYhcd0x_i35CeCBX-UMNFjBq8Vp3vZgdwCgTzCtt0-PKQ==";
          # !!! IMPORTANT !!! Replace with your InfluxDB 2.x organization name
          organization = "vector";
          # !!! IMPORTANT !!! Replace with your InfluxDB 2.x bucket name
          bucket = "vector";
        }];
      };

      # Telegraf's own Prometheus client output [[outputs.prometheus_client]]
      # Exposes Telegraf's internal metrics (e.g., CPU, memory usage of Telegraf)
      prometheus_client = [{
        listen = ":9273"; # Telegraf will serve Prometheus metrics on this port
      }];
    };
  };

  # 4. Prometheus Configuration
  services.prometheus = {
    enable = true;
    port = 9090; # Prometheus web UI will be available on http://localhost:9090

    scrapeConfigs = [
      # Scrape Prometheus itself
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [ "localhost:9090" ];
          }
        ];
      }
      # Scrape Telegraf for its internal metrics (exposed via prometheus_client)
      {
        job_name = "telegraf";
        static_configs = [
          {
            targets = [ "localhost:9273" ];
          }
        ];
      }
      # Scrape InfluxDB 2.x for its internal metrics
      # InfluxDB 2.x exposes /metrics on its main HTTP port
      {
        job_name = "influxdb";
        static_configs = [
          {
            targets = [ "localhost:8086" ];
          }
        ];
        metrics_path = "/metrics"; # Specify the endpoint for metrics
      }
    ];

    # Optional: Configure data retention for Prometheus (default is 15d)
    # retentionTime = "30d";
  };

  # 5. Grafana Configuration
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1"; # Bind to localhost; access via proxy or ssh tunnel
        http_port = 3000;
        domain = "vector.ngeran"; # Set your Grafana domain/hostname
      };
      security = {
        admin_user = "admin";
        # admin_password is set via systemd Environment variable and a secret file
      };
    };

    # Provision Grafana Data Sources
    # This option expects a 'settings' attribute, which contains the list of datasources.
    provision.datasources.settings = [
      {
        name = "InfluxDB-Juniper-Telemetry";
        type = "influxdb";
        access = "proxy"; # Grafana will proxy requests to InfluxDB
        url = "http://localhost:8086";
        isDefault = true; # Make this the default data source
        jsonData = {
          defaultBucket = "vector"; # Your InfluxDB 2.x bucket
          organization = "vector";   # Your InfluxDB 2.x organization
          version = "Flux";          # Use Flux language for querying
          tlsSkipVerify = false;
        };
        secureJsonData = {
          # !!! IMPORTANT !!! Replace with your InfluxDB 2.x token (read-only token recommended for Grafana)
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

    # Optional: Provision Grafana Dashboards from JSON files
    # provision.dashboards.settings = {
    #   providers = [{
    #     name = "default";
    #     orgId = 1;
    #     folder = "";
    #     type = "file";
    #     disableDelete = false;
    #     editable = true;
    #     options.path = "/etc/grafana/dashboards"; # Path to your dashboard JSON files
    #   }];
    # };
  };

  # 6. Systemd service configuration for Grafana's admin password
  # This sets an environment variable for the Grafana service.
  # This needs to be outside the 'services.grafana' block, directly under 'systemd.services'.
  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  # 7. Firewall Configuration
  # Open necessary ports for all services to be accessible.
  networking.firewall.allowedTCPPorts = [
    3000  # Grafana UI
    8086  # InfluxDB 2.x HTTP API
    50051 # Juniper JTI gRPC (Telegraf listens for Juniper here)
    9090  # Prometheus HTTP UI
    9273  # Telegraf's Prometheus client output
  ];

  # 8. Secret Management for Grafana Admin Password
  # This creates the secret file that Grafana reads.
  # The path 'config.nixpkgs.inputs.self + "/secrets/grafana-admin-password"'
  # assumes you are using a Nix flake and have a 'secrets' directory at your flake root.
  # If 'inputs.self' is not available here (e.g., if this module isn't directly within your flake output's specialArgs),
  # you might need to move this line back to your main configuration.nix or define 'inputs' appropriately.
  environment.etc."keys/grafana-admin-password".source =
    config.nixpkgs.inputs.self + "/secrets/grafana-admin-password";
}
