{ config, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;

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
      manager = {
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

      status = {
        separator_open = "";
        separator_close = "";
        separator_style = { fg = "#3c3836"; bg = "#3c3836"; };
        progress_label = { fg = "#ebdbb2"; bold = true; };
        progress_normal = { fg = "#504945"; bg = "#3c3836"; };
        progress_error = { fg = "#fb4934"; bg = "#3c3836"; };
        permissions_t = { fg = "#504945"; };
        permissions_r = { fg = "#b8bb26"; };
        permissions_w = { fg = "#fb4934"; };
        permissions_x = { fg = "#b8bb26"; };
        permissions_s = { fg = "#665c54"; };
      };

      mode = {
        normal_main = { fg = "#282828"; bg = "#A89984"; bold = true; };
        normal_alt = { fg = "#282828"; bg = "#A89984"; bold = true; };
        select_main = { fg = "#282828"; bg = "#b8bb26"; bold = true; };
        select_alt = { fg = "#282828"; bg = "#b8bb26"; bold = true; };
        unset_main = { fg = "#282828"; bg = "#d3869b"; bold = true; };
        unset_alt = { fg = "#282828"; bg = "#d3869b"; bold = true; };
      };

      input = {
        border = { fg = "#bdae93"; };
        title = { };
        value = { };
        selected = { reversed = true; };
      };

      select = {
        border = { fg = "#504945"; };
        active = { fg = "#fe8019"; };
        inactive = { };
      };

      tasks = {
        border = { fg = "#504945"; };
        title = { };
        hovered = { underline = true; };
      };

      which = {
        mask = { bg = "#3c3836"; };
        cand = { fg = "#83a598"; };
        rest = { fg = "#928374"; };
        desc = { fg = "#fe8019"; };
        separator = "  ";
        separator_style = { fg = "#504945"; };
      };

      help = {
        on = { fg = "#fe8019"; };
        exec = { fg = "#83a598"; };
        desc = { fg = "#928374"; };
        hovered = { bg = "#504945"; bold = true; };
        footer = { fg = "#3c3836"; bg = "#a89984"; };
      };

      filetype = {
        rules = [
          { mime = "image/*"; fg = "#83a598" };
          { mime = "video/*"; fg = "#b8bb26" };
          { mime = "audio/*"; fg = "#b8bb26" };
          { mime = "application/zip"; fg = "#fe8019" };
          { mime = "application/gzip"; fg = "#fe8019" };
          { mime = "application/x-tar"; fg = "#fe8019" };
          { mime = "application/x-bzip"; fg = "#fe8019" };
          { mime = "application/x-bzip2"; fg = "#fe8019" };
          { mime = "application/x-7z-compressed"; fg = "#fe8019" };
          { mime = "application/x-rar"; fg = "#fe8019" };
          { name = "*"; fg = "#a89984" };
          { name = "*/"; fg = "#83a598" };
        ];
      };
    };

    keymap = {
      manager.normal = [
        { key = "h"; action = "navigate_back"; };
        { key = "l"; action = "navigate_forward"; };
        # Add your custom keybindings here;
      ];
      # Define keymaps for other modes if needed (e.g., manager.select)
    };

    plugins = {
      # Configure Yazi plugins here if you use any
      # example_plugin.enable = true;
      # example_plugin.package = pkgs.someYaziPlugin;
      # example_plugin.settings = { ... };
    };

    initLua = null; # Path to a custom init.lua file if you have one
  };
}
