{ pkgs, ... }:

{
  programs.nixvim = {
    plugins = {
      blink-cmp.enable = true;
      blink-cmp.setupLspCapabilities = true;

      blink-cmp-dictionary.enable = true;
      blink-cmp-git.enable = true;
      blink-cmp-spell.enable = true;
      blink-emoji.enable = true;

      blink-cmp.settings = {
        keymap.preset = "super-tab";
        signature.enabled = true;
        fuzzy.enabled = false;

        sources = {
          default = [
            "buffer"
            "lsp"
            "path"
            "snippets"
            "dictionary"
            "emoji"
            "git"
            "spell"
          ];
          providers = {
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

        appearance = {
          nerd_font_variant = "mono";
          kind_icons = {
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
