{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lmstudio
  ];

  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio"; # replace with full path if necessary
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };

  # Optional: Electron / Qt environment fixes
  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
    OZONE_PLATFORM_HINT = "auto";
  };
}
