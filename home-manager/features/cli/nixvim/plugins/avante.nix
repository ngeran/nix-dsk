{ pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    plugins.avante = {
      enable = true;
      settings = {
        openai = {
          enabled = true; # Or whatever the option to enable OpenAI is
          api_key = pkgs.lib.getEnv "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";  # Read from environment variable
          model = "gpt-3.5-turbo"; # Or your preferred model
          temperature = 0.7; # Example parameter
          max_tokens = 200; # Example parameter
        };
        # Other avante.nvim settings...
      };
    };

    # Install Python dependencies if avante.nvim uses them for OpenAI interaction
   # python.packages = with pkgs.python3Packages; [
   #   openai
      # Any other required Python packages
   # ];
  };
}