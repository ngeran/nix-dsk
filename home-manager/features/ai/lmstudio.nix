{ config, pkgs, ... }:

{
  # Install the official LM Studio package
  home.packages = with pkgs; [
    lmstudio
  ];

  # Optional: create a desktop entry
  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio"; # ensure icon exists or provide full path
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };

  # Optional: enable Wayland support if needed
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
