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
          # BGP Neighbors
            "/network-instances/network-instance/protocols/protocol/bgp/neighbors"
          # BGP RIB
            "/bgp-rib"
          # OSPF
            "/network-instances/network-instance/protocols/protocol/ospfv2"
            "/ospfv2/interfaces/interface"
            "/ospfv2/areas/area"
          # LDP
            "/network-instances/network-instance/protocols/protocol/ldp"
            "/mpls/signaling-protocols/ldp"
            "/mpls/signaling-protocols/ldp/interfaces/interface"
          # MPLS
            "/mpls"
            "/mpls/lsps"
            "/mpls/lsps/constrained-path"
            "/mpls/lsps/static-lsps"
          # CPU Utilization
            "/system/cpus/cpu/state"
          # Interface Utilization & CRC Errors
            "/interfaces/interface/state"
            "/interfaces/interface/state/counters"
            "/interfaces/interface/state/counters/in-crc-errors"
            "/interfaces/interface/state/counters/out-errors"
            "/interfaces/interface/state/oper-status"
            "/interfaces/interface/state/admin-status"
            "/interfaces/interface/state/last-change"
          ];
          retry_delay = "1000ms";
        }];

        # gNMI Input
        gnmi = [{
          addresses = [ "10.100.255.2:6030" ];
          username = "root";
          password = "manolis1";
          tls_cert = "/etc/telegraf/crpd.crt";
          tls_key = "/etc/telegraf/crpd.key";
          insecure_skip_verify = true;
          name_override = "crpd_gnmi";
          subscription = [{
            path = "/interfaces/interface/state/counters";
            subscription_mode = "sample";
            sample_interval = "10s";
          }];
        }];

        # SNMP Input
        snmp = [{
          agents = [ "udp://192.168.1.1:161" ];  # Replace with your device IP
          version = 2;
          community = "public";  # Replace with your SNMP community
          name = "snmp_device";

          # Interface statistics
          field = [
            {
              name = "hostname";
              oid = "1.3.6.1.2.1.1.5.0";
            }
            {
              name = "uptime";
              oid = "1.3.6.1.2.1.1.3.0";
            }
          ];

          # Interface table
          table = [
            {
              name = "interface";
              inherit_tags = [ "hostname" ];
              oid = "1.3.6.1.2.1.2.2";

              field = [
                {
                  name = "ifInOctets";
                  oid = "1.3.6.1.2.1.2.2.1.10";
                }
                {
                  name = "ifOutOctets";
                  oid = "1.3.6.1.2.1.2.2.1.16";
                }
                {
                  name = "ifInErrors";
                  oid = "1.3.6.1.2.1.2.2.1.14";
                }
                {
                  name = "ifOutErrors";
                  oid = "1.3.6.1.2.1.2.2.1.20";
                }
              ];
            }
          ];
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
    6030  # gNMI port
  ];

  networking.firewall.allowedUDPPorts = [
    161   # SNMP
  ];

  environment.etc."keys/grafana-admin-password".source =
    inputs.self + "/secrets/grafana-admin-password";
}
