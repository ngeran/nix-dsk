{ icons, pkgs, ... }:

{
  # Extra configurations for nvim-dap
  extra = {
    # Additional packages needed for DAP UI and related tools
    packages = [
      pkgs.vimPlugins.nvim-dap-ui
    ];

    # Lua configuration for the DAP UI
    config = ''
      local dap, dapui = require "dap", require "dapui"

      -- Automatically open dapui when debugging starts and close when it ends
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Configure dap-ui appearance
      dapui.setup({ floating = { border = "rounded" } })
    '';
  };

  opts = {
    enable = true;

    # Configuring DAP signs (breakpoints, log points, etc.)
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

  # Key mappings for DAP actions
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
    {
      mode = "n";
      key = "<Leader>du";
      action.__raw = "function() require('dapui').toggle() end";
      options.desc = "Toggle Debugger UI";
    }
    {
      mode = "n";
      key = "<Leader>dh";
      action.__raw = "function() require('dap.ui.widgets').hover() end";
      options.desc = "Debugger Hover";
    }
    {
      mode = "n";
      key = "<F5>";
      action.__raw = "function() require('dap').continue() end";
      options.desc = "Debugger: Start";
    }
    # Shift+F5 to terminate the debugger
    {
      mode = "n";
      key = "<F17>";
      action.__raw = "function() require('dap').terminate() end";
      options.desc = "Debugger: Stop";
    }
    # F9 to toggle breakpoints
    {
      mode = "n";
      key = "<F9>";
      action.__raw = "function() require('dap').toggle_breakpoint() end";
      options.desc = "Debugger: Toggle Breakpoint";
    }
    # F10 to step over
    {
      mode = "n";
      key = "<F10>";
      action.__raw = "function() require('dap').step_over() end";
      options.desc = "Debugger: Step Over";
    }
    # F11 to step into
    {
      mode = "n";
      key = "<F11>";
      action.__raw = "function() require('dap').step_into() end";
      options.desc = "Debugger: Step Into";
    }
    # F23 to step out
    {
      mode = "n";
      key = "<F23>";
      action.__raw = "function() require('dap').step_out() end";
      options.desc = "Debugger: Step Out";
    }
  ];
}
