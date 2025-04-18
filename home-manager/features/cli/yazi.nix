{ config, lib, ... }:
{
  programs.yazi = {
    enable = true;

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

    theme = {
      status = lib.mkForce {
        separator_open = " "; # Using a common powerline separator
        separator_close = " ";
        separator_style = { fg = "#1d2021"; bg = "#1d2021"; }; # Dark background
        progress_label = { fg = "#ebdbb2"; bold = true; }; # Bright yellow
        progress_normal = { fg = "#504945"; bg = "#3c3836"; }; # Darker grey on dark background
        progress_error = { fg = "#fb4934"; bg = "#3c3836"; };  # Red on dark background
        permissions_t = { fg = "#ebdbb2"; }; # Bright yellow for file type
        permissions_r = { fg = "#a9b665"; }; # Green for read
        permissions_w = { fg = "#fabd2f"; }; # Yellow/Orange for write
        permissions_x = { fg = "#8ec07c"; }; # Light green for execute
        permissions_s = { fg = "#d3869b"; }; # Pink/Purple for setuid/etc.
      };
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
