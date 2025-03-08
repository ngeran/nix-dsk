{ config, pkgs, lib, inputs, ... }:{
# Thunar 
programs.thunar = {
  enable = true;

  plugins = with pkgs.xfce; [
    thunar-archive-plugin
    thunar-volman
  ];
};
 # Optional services for Thunar functionality
  services = {
    gvfs.enable = true; # Mount, trash, and other functionalities
    tumbler.enable = true; # Thumbnail support for images
  };
}