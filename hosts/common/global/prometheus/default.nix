{ config, pkgs, ... }: {
  services.prometheus = {
    enable = true;

    # Web UI will be available on http://localhost:9090
    port = 9090;

    # Configure which targets Prometheus scrapes
    scrapeConfigs = [
      {
        job_name = "prometheus";
        static_configs = [
          {
            targets = [ "localhost:9090" ];
          }
        ];
      }
    ];
  };
}
