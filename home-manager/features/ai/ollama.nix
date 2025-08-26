{ config, pkgs, ... }:
{
  # Remove the conflicting ollama systemd service - let the system service handle it
  # The system service is better for GPU access anyway

  # Install the packages for CLI usage only
  home.packages = with pkgs; [
    ollama  # For CLI access
  ];
}
