{
  programs.nixvim = {
    plugins = {
      dap = {
        enable = true;
        extensions = {
          dap-ui = {
            enable = true;
          };
          dap-virtual-text = {
            enable = true;
          };
          dap-python = {
            enable = true;
          };
          dap-go = {
            enable = true;
          };
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>d";
        action = "<cmd>lua require('dap_utils').toggle_dap()<CR>"; # Requires a separate dap_utils.lua file
        options = {
          silent = true;
          desc = "Toggle DAP/Breakpoint";
        };
      }

      {
        mode = "n";
        key = "<leader>dc";
        action = "<cmd>lua require('dap').continue()<CR>";
        options = {
          silent = true;
          desc = "Continue";
        };
      }

      {
        mode = "n";
        key = "<leader>db";
        action = "<cmd>lua require('dap').toggle_breakpoint()<CR>";
        options = {
          silent = true;
          desc = "Toggle Breakpoint";
        };
      }

      {
        mode = "n";
        key = "<leader>di";
        action = "<cmd>lua require('dap').step_into()<CR>";
        options = {
          silent = true;
          desc = "Step Into";
        };
      }

      {
        mode = "n";
        key = "<leader>do";
        action = "<cmd>lua require('dap').step_out()<CR>";
        options = {
          silent = true;
          desc = "Step Out";
        };
      }

      {
        mode = "n";
        key = "<leader>dv";
        action = "<cmd>lua require('dap').step_over()<CR>";
        options = {
          silent = true;
          desc = "Step Over";
        };
      }

      {
        mode = "n";
        key = "<leader>dr";
        action = "<cmd>lua require('dap').repl.open()<CR>";
        options = {
          silent = true;
          desc = "Repl";
        };
      }

      {
        mode = "n";
        key = "<leader>dl";
        action = "<cmd>lua require('dap').run_last()<CR>";
        options = {
          silent = true;
          desc = "Run Last";
        };
      }
    ];

    # Example Lua configuration (dap_utils.lua - Create this file!)
    luaConfig = ''
      local dap = require('dap')
      local dapui = require('dapui')

      local M = {}

      M.toggle_dap = function()
        if dap.is_running() then
          dapui.open()
        else
          dap.toggle_breakpoint()
        end
      end

      return M
    '';
  };
}