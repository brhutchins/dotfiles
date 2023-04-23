{ config, pkgs, ... }:

let
  legacyPkgs = import (builtins.fetchTarball "channel:nixos-21.11") {  };
  current-packages = with pkgs; [
    libjpeg
    zlib
    cairo
    kubectl
    pango
    libxml2
    postgresql
    alembic
    libpqxx
    libffi
    virtualenv
    xmlsec
    nodePackages.pyright
  ];

  python-stuff = with pkgs.python310Packages; [
    pkgs.python310Full
    pip
    setuptools
    # psycopg2
    # setuptools
    virtualenv
    virtualenvwrapper
    wheel
  ];

  legacy-packages = with legacyPkgs; [
    pgcli
  ];

  python-with-packages = pkgs.python310.withPackages (p: with p; [
    # pillow
    pip
    setuptools
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

  home.packages = current-packages ++ legacy-packages ++ python-stuff;

  # programs.zsh.envExtra = ''
  #   export AWS_CONFIG_FILE=$HOME/Hubs/devops/config/aws-vault.cfg
  # '';

  programs.zsh = {
    # profileExtra = ''
    #   eval "$(pyenv init --path)"
    # '';
    initExtra = ''
    #   eval "$(pyenv init -)"

    #   source ${pkgs.python39Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh
    export CPATH=`xcrun --show-sdk-path`/usr/include

    export LIBRARY_PATH=$LIBRARY_PATH:/usr/local/opt/openssl/lib/

    export VIRTUALENVWRAPPER_PYTHON=${pkgs.python39}/bin/python3.9
    source ${pkgs.python39Packages.virtualenvwrapper}/bin/virtualenvwrapper.sh
    '';
  };

  home.sessionVariables = {
    AWS_CONFIG_FILE = "${config.home.homeDirectory}/Hubs/devops/config/aws-vault.cfg";
    # VIRTUALENVWRAPPER_PYTHON="${pkgs.python39}/bin/python3.9";
  };

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  home.stateVersion = "21.11";
}
