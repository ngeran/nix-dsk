{ config, pkgs, inputs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "nikos";
  home.homeDirectory = "/home/nikos";

  imports = [
       ./features/cli
       ./features/dev
       ./features/gui
       ./features/desktop/hyprland
        ./features/desktop/hyprland/monitors.nix
       ./features/desktop/waybar
        inputs.nix-colors.homeManagerModules.default
        ];

  # Color Scheme
  colorScheme = inputs.nix-colors.colorSchemes.gruvbox-dark-hard;

  home.stateVersion = "24.11";

  # Packages
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles
  home.file = {
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  #  ------   -----   ------
  # | DP-3 | | DP-1| | DP-2 |
  #  ------   -----   ------
  monitors = [
    {
      name = "eDP-1";
      width = 1680;
      height = 1050;
      refreshRate = 60;
      x = 1920;
      y = 0;
      enabled = true;
    }
     {
      name = "HDMI-A-2";
      width = 1920;
      height = 1080;
      refreshRate = 60;
      x = 0;
      y = 0;
      enabled = true;
    }
  ];

}
