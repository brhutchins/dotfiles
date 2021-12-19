{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.editors.doom;
in
{
  options.local.editors.doom = {
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
    home.file.".doom.d/config.el".source = builtins.toPath "${cfg.dotfilesPath}/doom/config.el";
    home.file.".doom.d/custom.el".source = builtins.toPath "${cfg.dotfilesPath}/doom/custom.el";
    home.file.".doom.d/init.el".source = builtins.toPath "${cfg.dotfilesPath}/doom/init.el";
    home.file.".doom.d/packages.el".source = builtins.toPath "${cfg.dotfilesPath}/doom/packages.el";
  };
}
