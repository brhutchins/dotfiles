{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "barnaby";
  home.homeDirectory = "/home/barnaby";

  nixpkgs.config.allowUnfree = true;

  # Config modules
  # home.file.".config/home-manager".source = ./modules;

  imports = map (x: ../modules + x) [
    "/core/"
  ];

  local = {
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
  home.stateVersion = "23.05";
}
