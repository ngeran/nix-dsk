{ lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
     # window.opacity = 1.0; <-- Stylix contols the opacity
      };
  };
}
