{ config, pkgs, ... }:

{
     programs.home-manager.enable = true;

     home.username = "barnaby";
     home.homeDirectory = "/Users/barnaby";

     home.file.".config/home-manager".source = ../.dotfiles/nix/home-manager/modules;

     imports = [ ./home-manager/core ];
}
