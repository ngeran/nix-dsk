{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    plugins.avante = {
      enable = true;
      settings = {
        openai = {
          enabled = true; # Or whatever the option to enable OpenAI is
          #api_key = pkgs.lib.getEnv "OPENAI_API_KEY";  # Read API Key from environment variable!
          model = "gpt-3.5-turbo"; # Or your preferred model
          temperature = 0.7; # Example parameter
          max_tokens = 200; # Example parameter
        };
        # Other avante.nvim settings...
      };
    };
  };
}