{ config, pkgs, ... }: {
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
        admin_password = "changeme"; # Change this in production!
      };
    };
  };

  # Optional: ensure grafana is available in shell (e.g. for CLI usage)
  environment.systemPackages = with pkgs; [ grafana ];
}
