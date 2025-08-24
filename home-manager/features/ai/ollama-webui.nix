{ config, pkgs, ... }:
{
  # Remove the conflicting ollama systemd service - let the system service handle it
  # The system service is better for GPU access anyway

  # Keep only the open-webui service as a user service
  systemd.user.services.open-webui = {
    Unit = {
      Description = "Open WebUI for Ollama";
      After = [ "network.target" ];
    };
    Service = {
      Environment = [
        "DATA_DIR=${config.xdg.dataHome}/open-webui"
        # Point to the system Ollama service
        "OLLAMA_BASE_URL=http://localhost:11434"
      ];
      # Create the directory and set proper working directory
      ExecStartPre = [
        "${pkgs.coreutils}/bin/mkdir -p ${config.xdg.dataHome}/open-webui"
        "${pkgs.coreutils}/bin/chmod 755 ${config.xdg.dataHome}/open-webui"
      ];
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;
      # Set working directory to home directory
      WorkingDirectory = "%h";
      # Ensure proper logging
      StandardOutput = "journal";
      StandardError = "journal";
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Install the packages for CLI usage
  home.packages = with pkgs; [
    ollama      # For CLI access
    open-webui  # Web interface
  ];
}
