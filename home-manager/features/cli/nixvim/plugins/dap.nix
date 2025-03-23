{ icons, pkgs, ... }:

{
  # Enable the nvim-dap plugin and configure it
  opts = {
    enable = true;

    signs = {
      dapBreakpoint = {
        text = icons.DapBreakpoint;
        texthl = "DiagnosticInfo";
      };
      dapBreakpointCondition = {
        text = icons.DapBreakpointCondition;
        texthl = "DiagnosticInfo";
      };
      dapBreakpointRejected = {
        text = icons.DapBreakpointRejected;
        texthl = "DiagnosticError";
      };
      dapLogPoint = {
        text = icons.DapLogPoint;
        texthl = "DiagnosticInfo";
      };
      dapStopped = {
        text = icons.DapStopped;
        texthl = "DiagnosticWarn";
      };
    };
  };

  # Keybindings for the dap plugin
  rootOpts.keymaps = [
    {
      mode = "n";
      key = "<leader>dE";
      options.desc = "Evaluate input";
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expr)
            if expr then require("dapui").eval(expr, { enter = true }) end
          end)
        end
      '';
    }
    # Additional keybindings...
    {
      mode = "n";
      key = "<Leader>du";
      action.__raw = "function() require('dapui').toggle() end";
      options.desc = "Toggle Debugger UI";
    }
    # More keybindings...
  ];

  # This could enable nvim-dap inside nvim
  rootOpts.plugins.nvim-dap.enable = true;
}
