{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.darwin.core;
  stackline = pkgs.callPackage /Users/barnaby/.dotfiles/nix/packages/stackline {  };
in
{
  options.local.darwin.core = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    dotfilesPath = mkOption {
      type = types.path;
      default = (import ../../data).dotfilesPath;
    };
  };

  config = mkIf cfg.enable {

    home.shellAliases = {
      fw = "aerospace list-windows --all | fzf --bind 'enter:execute(bash -c \"aerospace focus --window-id {1}\")+abort'";
      nds = "nix run nix-darwin -- switch --flake ~/.dotfiles/nix/nix-darwin/ --impure";
    };

    # Temporary workaround for https://github.com/NixOS/nixpkgs/issues/196651
    # home.packages = with pkgs; [
    #  stackline
    # ];

    #####
    #
    # Hammerspoon

    # home.file.".hammerspoon/init.lua".source = "${cfg.dotfilesPath}/hammerspoon/init.lua";
    # home.file.".hammerspoon/stackline".source = stackline;


    #####
    #
    # skhd

    # home.file.".config/skhd".source = "${cfg.dotfilesPath}/skhd";


    #####
    #
    # Karabiner Elements

    home.file.".config/karabiner/karabiner.json".source = "${cfg.dotfilesPath}/karabiner/karabiner.json";

  };
}
