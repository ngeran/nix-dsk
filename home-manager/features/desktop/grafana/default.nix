{ config, pkgs, ... }: {
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "vector.ngeran";
    port = 3000;
    addr = "127.0.0.1";
  };
}
