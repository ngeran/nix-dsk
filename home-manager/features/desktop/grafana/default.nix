{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
      };
    };
  };

  # optional if you're exposing it remotely
  networking.firewall.allowedTCPPorts = [ 3000 ];
}
