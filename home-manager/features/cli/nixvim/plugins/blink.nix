{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      # Enable blink-cmp plugin
      blink-cmp.enable = true;
      blink-cmp.package = pkgs.vimPlugins.blink-cmp;

      # Enable blink-ripgrep-nvim plugin
      blink-ripgrep-nvim.enable = true;
      blink-ripgrep-nvim.package = pkgs.vimPlugins.blink-ripgrep-nvim;

      # Configure blink-cmp settings
      blink-cmp.settings = {
        keymap.preset = "super-tab";
        signature.enabled = true;
        sources = {
          default = [
            "buffer"
            "lsp"
            "path"
            "snippets"
            "copilot"
            "dictionary"
            "emoji"
            "git"
            "spell"
            "ripgrep"
          ];
          providers = {
            ripgrep = {
              name = "Ripgrep";
              module = "blink-ripgrep";
              score_offset = 1;
            };
            dictionary = {
              name = "Dict";
              module = "blink-cmp-dictionary";
              min_keyword_length = 3;
            };
            emoji = {
              name = "Emoji";
              module = "blink-emoji";
              score_offset = 1;
            };
            copilot = {
              name = "copilot";
              module = "blink-copilot";
              async = true;
              score_offset = 100;
            };
            lsp.score_offset = 4;
            spell = {
              name = "Spell";
              module = "blink-cmp-spell";
              score_offset = 1;
            };
            git = {
              name = "Git";
              module = "blink-cmp-git";
              enabled = true;
              score_offset = 100;
              should_show_items.__raw = ''
                function()
                  return vim.o.filetype == 'gitcommit' or vim.o.filetype == 'markdown'
                end
              '';
              opts.git_centers.github.issue.on_error.__raw = "function(_,_) return true end";
            };
          };
        };
        appearance.nerd_font_variant = "mono";
        appearance.kind_icons = {
          Text = "󰉿"; Method = ""; Function = "󰊕"; Constructor = "󰒓";
          Field = "󰜢"; Variable = "󰆦"; Property = "󰖷";
          Class = "󱡠"; Interface = "󱡠"; Struct = "󱡠"; Module = "󰅩";
          Unit = "󰪚"; Value = "󰦨"; Enum = "󰦨"; EnumMember = "󰦨";
          Keyword = "󰻾"; Constant = "󰏿";
          Snippet = "󱄽"; Color = "󰏘"; File = "󰈔"; Reference = "󰬲"; Folder = "󰉋";
          Event = "󱐋"; Operator = "󰪚"; TypeParameter = "󰬛";
          Error = "󰏭"; Warning = "󰏯"; Information = "󰏮"; Hint = "󰏭";
          Emoji = "🤶";
        };
        completion = {
          menu = {
            border = "none";
            draw = {
              gap = 1;
              treesitter = [ "lsp" ];
              columns = [
                { __unkeyed-1 = "label"; }
                {
                  __unkeyed-1 = "kind_icon";
                  __unkeyed-2 = "kind";
                  gap = 1;
                }
                { __unkeyed-1 = "source_name"; }
              ];
            };
          };
          trigger.show_in_snippet = false;
          documentation = {
            auto_show = true;
            window.border = "single";
          };
          accept.auto_brackets.enabled = false;
        };
      };
    };
  };
}
