{ config, pkgs, ... }:

{
  # Define the ollama systemd service
  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama Large Language Model Server";
      After = [ "network.target" ];
    };

    Service = {
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "on-failure";
      RestartSec = 5;
      # Optional: To allow access from other machines, uncomment the line below.
      # Environment = [ "OLLAMA_HOST=0.0.0.0" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Define the open-webui systemd service
  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI for Ollama";
      After = [ "ollama.service" ];
      BindsTo = [ "ollama.service" ];
    };

    Service = {
      # This is the new, more robust ExecStart line
      ExecStart = "${pkgs.python311.withPackages (ps: with ps; [ open-webui ])}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;

      # Optional: explicitly set a base URL if you're still getting connection errors
      Environment = [
        "OLLAMA_BASE_URL=http://localhost:11434"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Make sure the ollama package is available
  home.packages = with pkgs; [
    ollama
  ];
  # We no longer need to add open-webui to home.packages because it's managed by the service
}
