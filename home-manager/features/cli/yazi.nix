{ config, lib, ... }:
{
  programs.yazi = {
    enable = true;
    theme = {
      manager = lib.mkForce {
        cwd = { fg = "#83a598"; };
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
    mode = lib.mkForce  {
        normal_main = { fg = "#282828"; bg = "#A89984"; bold = true; };
        normal_alt = { fg = "#282828"; bg = "#A89984"; bold = true; };
        select_main = { fg = "#282828"; bg = "#b8bb26"; bold = true; };
        select_alt = { fg = "#282828"; bg = "#b8bb26"; bold = true; };
        unset_main = { fg = "#282828"; bg = "#d3869b"; bold = true; };
        unset_alt = { fg = "#282828"; bg = "#d3869b"; bold = true; };
      };

      input = lib.mkForce  {
        border = { fg = "#bdae93"; };
        title = { };
        value = { };
        selected = { reversed = true; };
      };

      select = lib.mkForce  {
        border = { fg = "#504945"; };
        active = { fg = "#fe8019"; };
        inactive = { };
      };

      tasks = lib.mkForce {
        border = { fg = "#504945"; };
        title = { };
        hovered = { underline = true; };
      };

      which = lib.mkForce {
        mask = { bg = "#3c3836"; };
        cand = { fg = "#83a598"; };
        rest = { fg = "#928374"; };
        desc = { fg = "#fe8019"; };
        separator = "  ";
        separator_style = { fg = "#504945"; };
      };

      help = lib.mkForce {
        on = { fg = "#fe8019"; };
        exec = { fg = "#83a598"; };
        desc = { fg = "#928374"; };
        hovered = { bg = "#504945"; bold = true; };
        footer = { fg = "#3c3836"; bg = "#a89984"; };
      };

      filetype = lib.mkForce  {
        rules = [
          { mime = "image/*"; fg = "#83a598"; }
          { mime = "video/*"; fg = "#b8bb26"; }
          { mime = "audio/*"; fg = "#b8bb26"; }
          { mime = "application/zip"; fg = "#fe8019"; }
          { mime = "application/gzip"; fg = "#fe8019"; }
          { mime = "application/x-tar"; fg = "#fe8019"; }
          { mime = "application/x-bzip"; fg = "#fe8019"; }
          { mime = "application/x-bzip2"; fg = "#fe8019"; }
          { mime = "application/x-7z-compressed"; fg = "#fe8019"; }
          { mime = "application/x-rar"; fg = "#fe8019"; }
          { name = "*"; fg = "#a89984"; }
          { name = "*/"; fg = "#83a598"; }
        ];
      };
    };
    keymap =  {
      manager.normal = [
        { key = "h"; action = "navigate_back"; }
        { key = "l"; action = "navigate_forward"; }
        # Add your custom keybindings here
      ];
      # Define keymaps for other modes if needed (e.g., manager.select)
    };

    plugins = lib.mkForce  {
      # Configure Yazi plugins here if you use any
      # example_plugin.enable = true;
      # example_plugin.package = pkgs.someYaziPlugin;
      # example_plugin.settings = { ... };
    };

    initLua = null; # Path to a custom init.lua file if you have one

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
