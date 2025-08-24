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
      # Set working directory to home
      WorkingDirectory = "%h";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Define the open-webui systemd service
  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI for Ollama";
      After = [ "network.target" ];
    };
    Service = {
      Environment = [
        "DATA_DIR=${config.xdg.dataHome}/open-webui"
      ];
      # Create the directory and set proper working directory
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${config.xdg.dataHome}/open-webui"
        "${pkgs.coreutils}/bin/chmod 755 ${config.xdg.dataHome}/open-webui"
      ];
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;
      # Set working directory to home directory (this is crucial!)
      WorkingDirectory = "%h";
      # Ensure proper logging
      StandardOutput = "journal";
      StandardError = "journal";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.packages = with pkgs; [
    ollama
    open-webui
  ];
}
