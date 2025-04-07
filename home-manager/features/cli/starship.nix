{ config, pkgs, ... }: {
  # Define the gruvbox colors as NixOS variables
  gruvboxColors = {
    gruvbox_bg0_h     = "#1d2021";
    gruvbox_bg0       = "#282828";
    gruvbox_bg1       = "#3c3836";
    gruvbox_bg2       = "#504945";
    gruvbox_bg3       = "#665c54";
    gruvbox_bg4       = "#7c6f64";
    gruvbox_fg        = "#ebdbb2";
    gruvbox_fg0       = "#fbf1c7";
    gruvbox_gray      = "#a89984";
    gruvbox_red       = "#cc241d";
    gruvbox_green     = "#98971a";
    gruvbox_yellow    = "#d79921";
    gruvbox_blue      = "#458588";
    gruvbox_purple    = "#b16286";
    gruvbox_aqua      = "#689d6a";
    gruvbox_orange    = "#d65d0e";
    gruvbox_bright_red    = "#fb4934";
    gruvbox_bright_green  = "#b8bb26";
    gruvbox_bright_yellow = "#fabd2f";
    gruvbox_bright_blue   = "#83a598";
    gruvbox_bright_purple = "#d3869b";
    gruvbox_bright_aqua   = "#8ec07c";
    gruvbox_bright_orange = "#fe8019";
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    settings = {
      # Add newline after each prompt
      add_newline = true;

      # Define the prompt format
      format = "$os$hostname$directory$git_branch$git_status$package$golang$python$nodejs$rust$java$docker_context$memory_usage$cmd_duration\n$time$line_break$status$character";

      # OS module configuration
      os = {
        format = "[ $symbol ]($style)";
        style = "${config.gruvboxColors.gruvbox_blue} bold";
        disabled = false;
        symbols.Linux = "󰻀";
        symbols.Ubuntu = "󰕈";
        symbols.Debian = "󰣚";
        symbols.Arch = "󰣇";
        symbols.Windows = "󰍲";
        symbols.Macos = "󰀵";
      };

      # Hostname module configuration
      hostname = {
        format = "[$hostname]($style) ";
        style = "${config.gruvboxColors.gruvbox_bright_orange} bold";
        trim_at = ".";
        ssh_only = false;
        disabled = false;
      };

      # Directory module configuration
      directory = {
        format = "[ 󰉖 $path ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_blue} bold";
        truncation_length = 4;
        truncate_to_repo = true;
        read_only = " 󰌾";
        read_only_style = "${config.gruvboxColors.gruvbox_bright_red}";
      };

      # Git Branch module configuration
      git_branch = {
        symbol = "󰘬";
        format = "[ $symbol $branch ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_purple} bold";
      };

      # Git Status module configuration
      git_status = {
        format = "([$all_status$ahead_behind]($style) )";
        style = "${config.gruvboxColors.gruvbox_bright_yellow} bold";
        conflicted = "󰞇";
        ahead = "󰁝 $count";
        behind = "󰁅 $count";
        diverged = "󰹹 $ahead_count $behind_count";
        untracked = "󰘓 $count";
        stashed = "󰏗 $count";
        modified = "󰙀 $count";
        staged = "[󰗅 $count](gruvbox_bright_green)";
        renamed = "󰑕 $count";
        deleted = "󰍷 $count";
      };

      # Package module configuration
      package = {
        symbol = "󰏗";
        format = "[ $symbol $version ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_orange} bold";
        disabled = false;
      };

      # Golang module configuration
      golang = {
        symbol = "󰟠";
        format = "[ $symbol ($version) ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_aqua} bold";
      };

      # Python module configuration
      python = {
        symbol = "";
        format = "[ $symbol ($version )]($style)";
        style = "${config.gruvboxColors.gruvbox_yellow} bold";
        pyenv_version_name = true;
      };

      # Node.js module configuration
      nodejs = {
        symbol = "";
        format = "[ $symbol ($version) ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_green} bold";
        disabled = false;
      };

      # Rust module configuration
      rust = {
        symbol = "";
        format = "[ $symbol ($version) ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_orange} bold";
      };

      # Java module configuration
      java = {
        symbol = "";
        format = "[ $symbol ($version) ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_red} bold";
      };

      # Docker Context module configuration
      docker_context = {
        symbol = "󰡨";
        format = "[ $symbol $context ]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_blue} bold";
        only_with_files = false;
        disabled = false;
      };

      # Memory usage module configuration
      memory_usage = {
        disabled = true;
        show_percentage = true;
        threshold = 75;
        symbol = "󰍛";
        format = "[$symbol($ram_pct)]($style)";
        style = "${config.gruvboxColors.gruvbox_bright_aqua}";
      };

      # Command duration module configuration
      cmd_duration = {
        min_time = 1000;
        format = "[ 󱑁 $duration ]($style)";
        style = "${config.gruvboxColors.gruvbox_gray} italic";
        disabled = false;
      };

      # Time module configuration
      time = {
        disabled = false;
        format = "[ 󱑆 $time ]($style)";
        time_format = "%T";
        style = "${config.gruvboxColors.gruvbox_bright_green}";
        utc_time_offset = "local";
      };

      # Status module configuration
      status = {
        symbol = "";
        style = "${config.gruvboxColors.gruvbox_bright_red}";
        success_symbol = "";
        format = "[$symbol]($style)";
        disabled = false;
      };

      # Character module configuration
      character = {
        success_symbol = "[❯](${config.gruvboxColors.gruvbox_bright_green})";
        error_symbol = "[❯](${config.gruvboxColors.gruvbox_bright_red})";
        vimcmd_symbol = "[❮](${config.gruvboxColors.gruvbox_bright_green})";
        vimcmd_replace_one_symbol = "[❮](${config.gruvboxColors.gruvbox_bright_purple})";
        vimcmd_replace_symbol = "[❮](${config.gruvboxColors.gruvbox_bright_purple})";
        vimcmd_visual_symbol = "[❮](${config.gruvboxColors.gruvbox_bright_yellow})";
      };
    };
  };
}
