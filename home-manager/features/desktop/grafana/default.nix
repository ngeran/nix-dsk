{ config, pkgs, ... }: {
  # grafana configuration
  services.grafana = {
    enable = true;
    domain = "webvector.com";
    port = 2342;
    addr = "127.0.0.1";
  };

  # nginx reverse proxy
  services.nginx.virtualHosts.${config.services.grafana.domain} = {
    locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.port}";
        proxyWebsockets = true;
    };
  };
}
