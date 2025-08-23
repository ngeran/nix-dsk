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
      # Ensure ollama serves on the correct IP and port if you need to
      # Expose it outside of localhost. By default it uses 127.0.0.1:11434
      # Environment = [ "OLLAMA_HOST=0.0.0.0" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Make ollama available in the user's environment
  home.packages = with pkgs; [
    ollama
  ];
}
