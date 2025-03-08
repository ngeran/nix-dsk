{
  programs = {
    git = {
      enable = true;

      userEmail = "ngeran@gmail.com";
      userName = "ngeran";

      extraConfig = {
        core.editor = "nvim";
        github.user = "ngeran";
        mergetool.prompt = false;
        pull.rebase = false;
      };
    };

    gh = {
      enable = true;

      settings = {
        git_protocol = "ssh";
      };
    };

    lazygit = {
      enable = true;
      settings = {
        gui = {
          theme = {
            activeBorderColor = [
              "blue"
              "bold"
            ];
            selectedLineBgColor = [ "white" ];
          };
        };
        git = {
          # Improves performance
          # https://github.com/jesseduffield/lazygit/issues/2875#issuecomment-1665376437
          log.order = "default";

          fetchAll = false;
        };
      };
    };
  };

  home.shellAliases = {
    lg = "lazygit";

    gfu = "git fetch upstream";
    gfo = "git fetch origin";
    gpc = "gh pr checkout";
  };
}