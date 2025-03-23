# dap.nix - Configuration for nvim-dap (Neovim Debugger)

{ lib, config, pkgs, icons, ... }:  # Accept the necessary arguments

{
  # Enable Neovim integration and configure plugins
  programs.nixvim = {
    enable = true;  # Enable Neovim

    # Configure the plugins used in Neovim
    plugins = {
      "mfussenegger/nvim-dap" = {};  # Enable nvim-dap plugin
    };
  };

  # Pass the icons argument for nvim-dap signs
  icons = {
    DapBreakpoint = "🔴";          # Icon for breakpoints
    DapBreakpointCondition = "🟠"; # Icon for conditional breakpoints
    DapBreakpointRejected = "❌";  # Icon for rejected breakpoints
    DapLogPoint = "💬";           # Icon for log points
    DapStopped = "▶️";            # Icon for stopped debugger state
  };

  # Configuration for nvim-dap (debugging)
  opts = {
    enable = true;  # Enable the nvim-dap plugin

    # Debugger signs, utilizing the icons passed in the arguments
    signs = {
      dapBreakpoint = {
        text = icons.DapBreakpoint;  # Icon for breakpoints
        texthl = "DiagnosticInfo";    # Highlight group for the breakpoint
      };
      dapBreakpointCondition = {
        text = icons.DapBreakpointCondition;  # Icon for conditional breakpoints
        texthl = "DiagnosticInfo";            # Highlight group
      };
      dapBreakpointRejected = {
        text = icons.DapBreakpointRejected;   # Icon for rejected breakpoints
        texthl = "DiagnosticError";           # Highlight group
      };
      dapLogPoint = {
        text = icons.DapLogPoint;  # Icon for log points
        texthl = "DiagnosticInfo"; # Highlight group
      };
      dapStopped = {
        text = icons.DapStopped;  # Icon for stopped (debugger paused)
        texthl = "DiagnosticWarn"; # Highlight group
      };
    };
  };

  # Keybindings for nvim-dap plugin
  keymaps = [
    {
      mode = "n";  # Normal mode keybinding
      key = "<leader>dE";  # Keybinding for Evaluate input
      options.desc = "Evaluate input";  # Description for the keybinding
      action.__raw = ''
        function()
          vim.ui.input({ prompt = "Expression: " }, function(expr)
            if expr then require("dapui").eval(expr, { enter = true }) end
          end)
        end
      '';
    }
    {
      mode = "n";  # Normal mode keybinding
      key = "<Leader>du";  # Keybinding to toggle the DAP UI
      action.__raw = "function() require('dapui').toggle() end";  # Action to toggle DAP UI
      options.desc = "Toggle Debugger UI";  # Description for the keybinding
    }
  ];

  # Enable the nvim-dap plugin in Neovim
  programs.nixvim.plugins.nvim-dap.enable = true;

}
