{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.legacyPackages.x86_64-linux.lmstudio
  ];

  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio";
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };

  home.sessionVariables = {
    QT_QPA_PLATFORM = "xcb";
    OZONE_PLATFORM_HINT = "auto";
  };
}
