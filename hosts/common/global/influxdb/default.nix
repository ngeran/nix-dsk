# /etc/nixos/configuration.nix

{ config, pkgs, ... }:

{
  # ... other system configurations ...

  environment.systemPackages = with pkgs; [
    # ... other packages you have installed ...
    influxdb
    influxdb-cli
  ];

  services.influxdb = {
    enable = true;
    # You can add more configuration options here.
    # For example, to change the data directory:
    # dataDir = "/var/lib/influxdb";
    #
    # Refer to the Nixpkgs documentation for influxdb for all available options:
    # You can search for "influxdb" on https://search.nixos.org/options
  };

  # ... rest of your configuration ...
}
