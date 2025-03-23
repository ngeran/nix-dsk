{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;

    plugins.avante = {
      enable = true;
      settings = {
        provider = "codeium"; # Switch to Codeium as the provider
        codeium = {
          enabled = true;  # Enable Codeium
          # Optionally, you can set API key if needed (Codeium might require one, check docs)
          # api_key = pkgs.lib.getEnv "CODEIUM_API_KEY";  # Read API Key from environment variable!
          model = "codeium"; # This could be specific model info, if needed (check Codeium docs)
          temperature = 0.7; # Example parameter for controlling randomness
          max_tokens = 200; # Example parameter to control the maximum completion length
        };
        # Other avante.nvim settings...
      };
    };
  };
}
