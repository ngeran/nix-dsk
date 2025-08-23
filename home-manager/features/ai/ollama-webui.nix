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
      After = [ "ollama.service" ];
      BindsTo = [ "ollama.service" ];
    };

    Service = {
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;

      # Set a writable directory for Open WebUI data
      Environment = [
        "OLLAMA_BASE_URL=http://localhost:11434"
        "OPEN_WEBUI_DATA_DIR=%h/open-webui-data"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # The open-webui package must be added to home.packages for the ExecStart
  # command to work. The Nix store path is made available by this.
  home.packages = with pkgs; [
    ollama
    open-webui
  ];
}
