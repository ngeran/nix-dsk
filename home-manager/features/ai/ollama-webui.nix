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
      # The corrected single-line ExecStart command
      ExecStart = "${pkgs.bash}/bin/bash -c \"OPEN_WEBUI_DATA_DIR=${config.xdg.dataHome}/open-webui-data ${pkgs.open-webui}/bin/open-webui serve\"";
      Restart = "on-failure";
      RestartSec = 10;
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
