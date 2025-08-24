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
        # Use a simpler data directory path
        "DATA_DIR=${config.xdg.dataHome}/open-webui"
        "STATIC_DIR=${config.xdg.dataHome}/open-webui/static"
      ];
      # Create the directory structure before starting
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${config.xdg.dataHome}/open-webui"
        "${pkgs.coreutils}/bin/mkdir -p ${config.xdg.dataHome}/open-webui/static"
        "${pkgs.coreutils}/bin/chmod -R 755 ${config.xdg.dataHome}/open-webui"
      ];
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;
      # Ensure the service runs with proper user permissions
      User = "%i";
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
