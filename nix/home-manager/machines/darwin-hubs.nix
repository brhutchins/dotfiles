{ config, pkgs, ... }:

let
  python-with-packages = pkgs.python37.withPackages (p: with p; [
    # pillow
    pip
    # psycopg2
    # setuptools
    virtualenv
    virtualenvwrapper
    wheel
  ]);
in
{
  programs.home-manager.enable = true;

  home.username = "barnaby";
  home.homeDirectory = "/Users/barnaby";

  #home.file.".config/home-manager".source = ../.dotfiles/nix/home-manager/modules;

  imports = [ ../modules/core ];
  local = {
    core.gui.enable = true;
  };

  home.packages = with pkgs; [
    libjpeg
    zlib
    cairo
    pango
    libxml2
    python39Packages.pip
    python39Packages.setuptools
    postgresql
    alembic
    libpqxx
    libffi
    virtualenv
    xmlsec
  ];

  # programs.zsh.envExtra = ''
  #   export AWS_CONFIG_FILE=$HOME/Hubs/devops/config/aws-vault.cfg
  # '';

  programs.zsh = {
    profileExtra = ''
      eval "$(pyenv init --path)"
    '';
    initExtra = ''
      eval "$(pyenv init -)"

      source ${pkgs.python37Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh
    '';
  };

  home.sessionVariables = {
    AWS_CONFIG_FILE = "${config.home.homeDirectory}/Hubs/devops/config/aws-vault.cfg";
    VIRTUALENVWRAPPER_PYTHON="${pkgs.python37}/bin/python3.7";
  };

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

}
