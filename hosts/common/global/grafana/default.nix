{ config, pkgs, lib, inputs, ... }:

{
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
        # ⚠️ Do not set admin_password here
      };
    };
  };

  # Inject the password at runtime via environment variable
  systemd.services.grafana.serviceConfig.Environment = [
    "GF_SECURITY_ADMIN_PASSWORD_FILE=/run/keys/grafana-admin-password"
  ];

  # ✅ Use flake-root-relative path to the secret
  environment.etc."keys/grafana-admin-password".source =
    inputs.self + "/secrets/grafana-admin-password";

  environment.systemPackages = with pkgs; [ grafana ];
}
