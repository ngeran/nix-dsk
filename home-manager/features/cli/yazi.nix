{ config, lib, ... }:
{
  programs.yazi = {
    enable = true;

theme = {
  manager = lib.mkForce {
    cwd = { fg = "#00ff00"; }; # Set the current directory text to bright red
    hovered = { fg = "#282828"; bg = "#83a598"; };
    preview_hovered = { underline = true; };
    find_keyword = { fg = "#b8bb26"; italic = true; };
    find_position = { fg = "#fe8019"; bg = "reset"; italic = true; };
    marker_selected = { fg = "#b8bb26"; bg = "#b8bb26"; };
    marker_copied = { fg = "#b8bb26"; bg = "#b8bb26"; };
    marker_cut = { fg = "#fb4934"; bg = "#fb4934"; };
    tab_active = { fg = "#282828"; bg = "#504945"; };
    tab_inactive = { fg = "#a89984"; bg = "#3c3836"; };
    tab_width = 1;
    border_symbol = "│";
    border_style = { fg = "#665c54"; };
    # syntect_theme = "~/.config/yazi/Gruvbox-Dark.tmTheme";
  };

  status = lib.mkForce {
    background = "#00ff00"; # Set the status bar background to bright green
    separator_open = " ";
    separator_close = " ";
    separator_style = { fg = "#928374"; bg = "#928374"; };
    progress_label = { fg = "#ebdbb2"; bold = true; };
    progress_normal = { fg = "#504945"; bg = "#3c3836"; };
    progress_error = { fg = "#fb4934"; bg = "#3c3836"; };
    permissions_t = { fg = "#ebdbb2"; };
    permissions_r = { fg = "#a9b665"; };
    permissions_w = { fg = "#fabd2f"; };
    permissions_x = { fg = "#8ec07c"; };
    permissions_s = { fg = "#d3869b"; };
  };
};

    settings = {
      manager = {
        show_hidden = true;
        sort_by = "natural";
        # Add other manager settings as needed
      };
      preview = {
        max_width = 80;
        max_height = 20;
        # Add other preview settings
      };
      opener.default = [
        { run = "xdg-open \"$@\""; block = false; }
      ];
      # Add other top-level settings from yazi.toml here
    };
    shellWrapperName = "r";

    keymap = {
      manager.prepend_keymap = [
        {
          on = [ "<C-f>" ];
          run = "find";
        }
        {
          on = [ "A" ];
          run = "create --dir";
        }
        {
          on = [
            "g"
            "d"
          ];
          run = "cd ${config.xdg.userDirs.download}";
          desc = "Go to the downloads directory";
        }
        {
          on = [
            "g"
            "t"
          ];
          run = "cd ~/temp";
          desc = "Go to the temp directory";
        }
      ];
    };
  };
}
