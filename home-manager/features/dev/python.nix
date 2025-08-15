{
  pkgs,
  config,
  ...
}:
let
  jsnapy = pkgs.python3Packages.buildPythonPackage rec {
    pname = "jsnapy";
    version = "1.3.8";
    pyproject = true;

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "b1a4c6f048af4b048ff843541da94384320876b80b0a8b97c99fb00b8614e57d";
    };

    build-system = with pkgs.python3Packages; [ setuptools ];

    propagatedBuildInputs = with pkgs.python3Packages; [
      junos-eznc
      pyyaml
      lxml
      colorama
    ];

    # Skip tests as they may require additional setup or network access
    doCheck = false;

    # Patch to prevent installation to /etc/jsnapy
    postPatch = ''
      substituteInPlace setup.py \
        --replace "'data_files': [('/etc/jsnapy', ['jnpr/jsnapy/jsnapy.cfg', 'jnpr/jsnapy/logging.yml'])]," "" \
        --replace "'/etc/jsnapy'," ""
    '';

    meta = with pkgs.lib; {
      description = "Junos Snapshot Administrator in Python";
      homepage = "https://github.com/Juniper/jsnapy";
      license = licenses.asl20;
      maintainers = [];
    };
  };
in
{
  home = {
    packages = with pkgs; [
      (python3.withPackages (pypkgs: with pypkgs; [
        pip
        requests
        setuptools
        matplotlib
        numpy
        torch
        jinja2
        types-jinja2
        types-pyyaml
        types-requests
        pyyaml
        flask
        junos-eznc
        netmiko
        mypy
        lxml
        openai
        gitpython
        paramiko
        tabulate
        prometheus_client
        git-filter-repo
        jsnapy
      ]))
    ];

    # Point JSNAPy to the project's validation folder for config and logging files
    sessionVariables = {
      MYPY_CACHE_DIR = "${config.xdg.cacheHome}/mypy";
      JSNAPY_HOME = "${config.home.homeDirectory}/vlabs/python_pipeline/tools/validation";
    };
  };

  programs = {
    ruff = {
      enable = true;
      settings = {
        line-length = 100;
      };
    };

    nixvim = {
      filetype.extension.gin = "gin";
      files."after/ftplugin/python.lua" = {
        autoCmd = [
          {
            event = "BufWritePre";
            callback.__raw = ''
              function()
                vim.lsp.buf.code_action {
                  context = {only = {"source.fixAll.ruff"}},
                  apply = true
                }
              end
            '';
          }
        ];
      };
      plugins = {
        treesitter.languageRegister.python = [ "gin" ];
        lsp.servers = {
          ruff.enable = true;
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                jedi_completion.fuzzy = true;
              };
            };
          };
        };
      };
    };
  };
}
