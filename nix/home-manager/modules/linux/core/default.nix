{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.linux.core;
in
{
  options.local.linux.core = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };

    services.lorri.enable = true;
  };

}
