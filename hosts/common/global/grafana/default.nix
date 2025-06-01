{ config, pkgs, ... }: {
  services.grafana = {
    enable = true;

    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "vector.ngeran";
      };

      security = {
        admin_user = "admin";
        # ⚠️ REMOVE THIS LINE to avoid storing plaintext password
        # admin_password = "changeme";
      };
    };
  };

  # Securely inject the password file at runtime
  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  # Provide the password file via environment.etc (optional location)
  environment.etc."keys/grafana-admin-password".source = ./secrets/grafana-admin-password;

  # Optional: include grafana CLI tools
  environment.systemPackages = with pkgs; [ grafana ];
}
