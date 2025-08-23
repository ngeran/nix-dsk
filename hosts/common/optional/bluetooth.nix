{ config, lib, pkgs, ... }:

{
  # Enable Bluetooth hardware + bluetoothd service
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez; # Explicitly use BlueZ
  };

  # Optional GUI manager for Bluetooth
  services.blueman.enable = true;

  # Ensure firmware blobs are available
  hardware.enableRedistributableFirmware = true;

  # Force-load MediaTek MT7921e driver at boot
  boot.kernelModules = [ "mt7922" ];
}
