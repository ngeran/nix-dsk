{ config, pkgs, ... }:

{
  # Enable the n8n service for your user.
  systemd.user.services.n8n = {
    # The 'Unit' attribute holds all the options for the [Unit] section of the service file.
    Unit = {
      Description = "n8n workflow automation";
      After = [ "network-online.target" ];
    };

    # The 'Service' attribute holds all the options for the [Service] section.
    Service = {
      ExecStart = "${pkgs.n8n}/bin/n8n start";
      WorkingDirectory = "%h/n8n-data";
      Environment = [
        "N8N_HOST=localhost"
        "N8N_PORT=5678"
      ];
    };

    # The 'Install' attribute holds all the options for the [Install] section.
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Declaratively create the data directory.
  # The `writeTextDir` function creates a directory with a file inside it,
  # which is the correct way to have Nix manage a directory for you.
  home.file."n8n-data".source = pkgs.writeTextDir "n8n-data/.gitkeep" "";

  home.packages = with pkgs; [
    n8n
  ];
}
