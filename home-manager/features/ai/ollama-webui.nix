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
      # This line is the culprit. You need to add 'serve' at the end.
      # WRONG: ExecStart = "${pkgs.open-webui}/bin/open-webui";
      # CORRECT:
      ExecStart = "${pkgs.open-webui}/bin/open-webui serve";
      Restart = "on-failure";
      RestartSec = 10;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
  # Add packages to the user's environment
  home.packages = with pkgs; [
    ollama
    open-webui
  ];
}
