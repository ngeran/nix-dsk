{
  wayland.windowManager.hyprland.settings = {
   bind = [
      # Application launchers
      "$mainMod,        X, exec, $terminal"    # Launch terminal (e.g., kitty, alacritty)
      "$mainMod,        B, exec, $browser"     # Launch browser (e.g., firefox, chrome)
      "$mainMod,        R, exec, $fileManager" # Launch file manager (e.g., thunar, nautilus)
      "$mainMod,        D, exec, $menu -show drun" # Launch application launcher (e.g., rofi, wofi, wayland-dmenu)

      # Window management
      "$mainMod SHIFT, C, killactive,"        # Close the active window
      "$mainMod SHIFT, Q, exit,"              # Exit Hyprland session
      "$mainMod,        F, togglefloating,"   # Toggle floating mode for the active window
      "$mainMod,        P, pseudo,"           # Toggle pseudo-tiling mode (makes a window appear tiled but allows free movement)
      "$mainMod,        T, togglesplit,"      # Toggle split ratio for master/stack layout

      # Utilities and specific commands
      "$mainMod,        E, exec, bemoji -cn"  # Launch bemoji for emoji selection
      "$mainMod,        V, exec, cliphist list | $menu --dmenu | cliphist decode | wl-copy" # Select from clipboard history
      "$mainMod,        W, exec, pkill -SIGUSR2 waybar" # Reload Waybar (e.g., to refresh modules)
      "$mainMod SHIFT, W, exec, pkill -SIGUSR1 waybar" # Restart Waybar
      "$mainMod,        Q, exec, loginctl lock-session" # Lock the session
      "$mainMod,        P, exec, hyprpicker -an" # Launch Hyprpicker for color picking
      "$mainMod,        N, exec, swaync-client -t" # Toggle SwayNC notification center
      ", Print, exec, grimblast --notify --freeze copysave area" # Screenshot selected area and copy/save

      # Moving focus between windows
      # These use directions (l, r, u, d)
      "$mainMod, J, movefocus, l" # Mod + J to focus left
      "$mainMod, K, movefocus, r" # Mod + K to focus right
      "$mainMod, U, movefocus, u" # Mod + U to focus up
      "$mainMod, D, movefocus, d" # Mod + D to focus down

      # Moving/swapping windows
      # These also use directions (l, r, u, d) to swap windows
      "$mainMod SHIFT, J, swapwindow, l" # Shift + Mod + J to swap window left
      "$mainMod SHIFT, K, swapwindow, r" # Shift + Mod + K to swap window right
      "$mainMod SHIFT, U, swapwindow, u" # Shift + Mod + U to swap window up
      "$mainMod SHIFT, D, swapwindow, d" # Shift + Mod + D to swap window down

      # Resizing active window
      # These use pixel values for width (X) and height (Y) changes
      "$mainMod, H, resizeactive, -60 0" # Mod + H to decrease width by 60px
      "$mainMod, L, resizeactive, 60 0"  # Mod + L to increase width by 60px
      "$mainMod, U, resizeactive, 0 -60" # Mod + U to decrease height by 60px
      "$mainMod, D, resizeactive, 0 60"  # Mod + D to increase height by 60px

      # Switching workspaces
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # Moving windows to workspaces
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"

      # Scratchpad
      "$mainMod,       S, togglespecialworkspace,  magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"
    ];

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume,  exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume,  exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute,         exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute,      exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      "$mainMod, bracketright, exec, brightnessctl s 10%+"
      "$mainMod, bracketleft,  exec, brightnessctl s 10%-"
    ];

    # Audio playback
    bindl = [
      ", XF86AudioNext,  exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay,  exec, playerctl play-pause"
      ", XF86AudioPrev,  exec, playerctl previous"
    ];
  };
}
