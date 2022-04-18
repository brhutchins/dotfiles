{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.editors.helix;
  helix-22-03 = pkgs.helix.overrideAttrs (
    o: rec {
      pname = "helix";
      version = "22.03";
      src = pkgs.fetchFromGitHub {
        owner = "helix-editor";
        repo = pname;
        rev = "${version}";
        fetchSubmodules = true;
        sha256 = "sha256-anUYKgr61QQmdraSYpvFY/2sG5hkN3a2MwplNZMEyfI=";
      };
      cargoDeps = o.cargoDeps.overrideAttrs (lib.const {
        name = "${pname}-vendor.tar.gz";
        inherit src;
        outputHash = "sha256-55QzA44HAS9X6J5fQjL5mTGOqXALxzQeJ+Fy+YfDg/g=";
      });
      # cargoSha256 = "sha256-zJQ+KvO+6iUIb0eJ+LnMbitxaqTxfqgu7XXj3j0GiX4=";
    }
  );
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
      package = helix-22-03;
      settings = {
        theme = "monokai_pro_machine";
        editor = {
          cursor-shape = {
            insert = "bar";
          };
        };
      };
      # languages = [
      #   {
      #     name = "python";
      #     language-server = { command = "pyright"; };
      #   }
      # ];
    };
  };
}
