{ config, pkgs, ... }:

{
  # Enable the n8n service for your user
  systemd.user.services.n8n = {
    enable = true;
    description = "n8n workflow automation";
    after = [ "network-online.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      # The Nixpkgs package for n8n.
      # This provides a pre-configured binary that includes dependencies.
      ExecStart = "${pkgs.n8n}/bin/n8n start --tunnel";

      # The working directory for n8n.
      # You can specify a custom path to store your workflows, credentials, etc.
      WorkingDirectory = "%h/.n8n";

      # n8n uses environment variables for configuration.
      # This is how you set them declaratively.
      Environment = [
        "N8N_HOST=localhost"
        "N8N_PORT=5678"
        # Example of other configurations:
        # "N8N_DIAGNOSTICS_ENABLED=false"
        # "N8N_USER_FOLDER=%h/my-n8n-data"
      ];
    };
  };

  # You also need to ensure that the n8n package is available to your user profile.
  home.packages = with pkgs; [
    n8n
  ];

  # This is a good practice to ensure the n8n data directory is created.
  # If you change N8N_USER_FOLDER, make sure this path matches.
  home.file.".n8n" = {
    source = ./n8n-data; # Assumes a directory named n8n-data in your config
    recursive = true;
  };
}
