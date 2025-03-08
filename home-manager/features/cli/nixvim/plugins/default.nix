{
  lib,
  config,
  ...
}:
{
  imports = [
    ./barbar.nix        # Tabline plugin
    ./comment.nix       # Commenting plugin
    ./lsp.nix           # Language Server Protocol configuration
    ./lualine.nix       # Statusline plugin
    ./neo-tree.nix      # File explorer plugin
    ./telescope.nix     # Fuzzy finder plugin
    ./treesitter.nix    # Incremental parsing for syntax highlighting and more
    ./markdown-preview.nix # Markdown preview plugin
    ./harpoon.nix       # Easily jump between files
    ./neorg.nix         # Note-taking plugin
    ./startify.nix      # Start screen plugin (duplicate entry - see below)
    ./vimtex.nix        # LaTeX support
    ./floaterm.nix      # Floating terminal plugin
    ./lazygit.nix       # Integration with lazygit
    ./noice.nix         # Notification plugin
    ./which-key.nix     # Keybinding hints plugin
    ./snacks.nix        # Snippet plugin (consider combining with luasnip)
    ./theme-gruvbox.nix # gruvbox theme
  ]; # Imports configuration files for various plugins

  programs.nixvim = {
    #colorschemes.gruvbox.enable = true; # Enables the Gruvbox colorscheme

    plugins = {
      # Lazy loading (consider using `lazy.nvim` directly for more control)
      lz-n.enable = true;  # Plugin manager (consider switching to lazy.nvim)

      web-devicons.enable = true; # Adds icons to various plugins (e.g., neo-tree, telescope)

      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "+";      # Git sign for added lines
          change.text = "~";   # Git sign for changed lines
        };
      };

      nvim-autopairs.enable = true; # Automatically adds and removes pairs of characters (e.g., parentheses, quotes)

      colorizer = {
        enable = true;
        settings.user_default_options.names = false; # Disables displaying color names
      };

      oil = {
        enable = true;
        lazyLoad.settings.cmd = "Oil"; # Lazy loads the oil plugin when the "Oil" command is used
      };

      luasnip = {
        enable = true; # Enables the LuaSnip snippet plugin
      };

      trim = {
        enable = true;
        settings = {
          highlight = true; # Highlights trailing whitespace
          ft_blocklist = [    # List of filetypes where trailing whitespace highlighting is disabled
            "checkhealth"   # Neovim's health check output
            "floaterm"     # Floaterm windows
            "lspinfo"       # LSP info output
            "neo-tree"      # Neo-tree file explorer
            "TelescopePrompt" # Telescope prompt window
          ];
        };
      };
    };
  };
}