{
  # Enable Bluetooth hardware
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable the BlueZ service (required for PipeWire to see Bluetooth devices)
  services.blueman.enable = true;
  services.bluez = {
    enable = true;
    # Optional: better codec support (PipeWire handles this too)
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };

  # Ensure firmware availability
  hardware.enableRedistributableFirmware = true;
}
