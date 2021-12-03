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
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yabai
      skhd
    ];
  };

  #####
  #
  # Hammerspoon

  home.file.".hammerspoon".source = ../../../hammerspoon;
}
