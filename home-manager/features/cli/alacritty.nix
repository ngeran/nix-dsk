{ lib, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
     # window.opacity = 1.0; <-- Stylix contols the opacity 

      font = {
        builtin_box_drawing = true;
        normal = {
          style = lib.mkForce "Bold";
        };
      };
    };
  };
}

