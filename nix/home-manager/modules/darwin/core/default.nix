{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.darwin.core;
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
    home.packages = with pkgs; [
    ];

    #####
    #
    # Hammerspoon

    home.file.".hammerspoon".source = "${cfg.dotfilesPath}/hammerspoon";


    #####
    #
    # skhd

    home.file.".config/skhd".source = "${cfg.dotfilesPath}/skhd";
  };
}
