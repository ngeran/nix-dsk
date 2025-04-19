{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    papirus-icon-theme
    pcmanfm-qt
  ];
  qt = {
    enable = true;
    platformTheme.name = "gtk"; # Or lib.mkForce "gtk"; if you prefer
    style = {
      package = pkgs.adwaita-qt;
      name = lib.mkForce "adwaita-dark";
    };
  };
}
