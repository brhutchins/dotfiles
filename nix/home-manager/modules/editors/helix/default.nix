{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.editors.helix;
in
{
  options.local.editors.helix = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix;
      settings = {
        theme = "monokai_pro_machine";
        editor = {
          cursor-shape = {
            insert = "bar";
          };
        };
      };
    };
  };
}
