{ pkgs, ... }:{

 programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    #theme = ./style.rasi;

    extraConfig = {
      modi = "drun,filebrowser";
      font = "Noto Sans CJK JP 12";
      show-icons = false;
      disable-history = true;
      hover-select = true;
      bw = 0;
      display-drun = "";
      display-window = "";
      display-combi = "";
      icon-theme = "Fluent-dark";
      terminal = "kitty";
      drun-match-fields = "name";
      drun-display-format = "{name}";
      me-select-entry = "";
      me-accept-entry = "MousePrimary";
      kb-cancel = "Escape,MouseMiddle";
    };
  };


}

