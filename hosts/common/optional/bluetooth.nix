{
  # Enable Bluetooth hardware + bluetoothd service
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Optional GUI manager for Bluetooth
  services.blueman.enable = true;

  # Ensure firmware blobs are available
  hardware.enableRedistributableFirmware = true;
}
