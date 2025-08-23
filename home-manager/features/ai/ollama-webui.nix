{ config, pkgs, ... }:

{
  # Define the ollama systemd service
  systemd.user.services.ollama = {
    Unit = {
      Description = "Ollama Large Language Model Server";
      After = [ "network.target" ];
    };

    Service = {
      # The Ollama executable is available through the pkgs.ollama package
      ExecStart = "${pkgs.ollama}/bin/ollama serve";
      Restart = "on-failure";
      RestartSec = 5; # Add a 5-second delay before restarting
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
      # Ensure Open WebUI starts after the Ollama service is up and running
      After = [ "ollama.service" ];
      # Use BindsTo to automatically stop Open WebUI if Ollama stops
      BindsTo = [ "ollama.service" ];
    };

    Service = {
      # The fix is here: we now pass the "serve" command to the executable
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10; # Add a 10-second delay to account for Ollama startup time
      # Optional: You can specify the port or other environment variables if needed
      # e.g., "UVICORN_PORT=8080"
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Add both packages to the user's environment so the executables are
  # available in the terminal.
  home.packages = with pkgs; [
    ollama
    open-webui
  ];
}
