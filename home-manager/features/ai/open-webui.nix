{ config, pkgs, ... }:

{
  # Define the open-webui systemd service
  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI for Ollama";
      # Ensure Open WebUI starts after the Ollama service is up and running
      After = [ "ollama.service" ];
    };

    Service = {
      # The open-webui executable is available through the pkgs.open-webui package
      ExecStart = "${pkgs.open-webui}/bin/open-webui";
      Restart = "on-failure";
      # You can specify the port or other environment variables if needed
      # e.g., "UVICORN_PORT=8080"
      # The default port is 8080.
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Add open-webui to the user's environment
  home.packages = with pkgs; [
    open-webui
  ];
}
