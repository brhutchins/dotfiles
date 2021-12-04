{ config, pkgs, ... }:

let
  modulesPath = ./nix/home-manager/modules;
in
{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "barnaby";
  home.homeDirectory = "/Users/barnaby";

  # Config modules
  home.file.".config/home-manager".source = modulesPath;

  imports = map (x: modulesPath + x) [
    "/core/"
  ];

  local = {
    core.gui.enable = true;
  };

  # Packages to install
  home.packages = with pkgs; [
  ];

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  # This value determines the Home Manager release that your
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
