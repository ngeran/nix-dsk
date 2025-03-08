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
      name = "DP-1";
      width = 3440;
      height = 1440;
      refreshRate = 120;
      x = 0;
      y = 0;
      enabled = true;
    }
    # Add more monitors as needed
  ];

}
