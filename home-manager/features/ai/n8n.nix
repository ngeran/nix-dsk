{ config, pkgs, ... }:

{
  systemd.user.services.n8n = {
    Unit = {
      Description = "n8n workflow automation";
      After = [ "network-online.target" ];
    };
    Service = {
      ExecStart = "${pkgs.n8n}/bin/n8n start";
      WorkingDirectory = "%h/n8n-data";
      Environment = [
        "N8N_HOST=localhost"
        "N8N_PORT=5678"
      ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = with pkgs; [
    n8n
  ];
}
