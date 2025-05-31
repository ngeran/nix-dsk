{ config, pkgs, ... }: {
  # Ensure Grafana package is available
  environment.systemPackages = with pkgs; [ grafana ];

  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "vector.ngeran";
    port = 3000;
    addr = "127.0.0.1";
  };
}
