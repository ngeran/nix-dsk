{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lmstudio
  ];

  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio";
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };
}
