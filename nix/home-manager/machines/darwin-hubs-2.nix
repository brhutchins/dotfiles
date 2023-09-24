{ pkgs, ... }:
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.barnaby = { pkgs, ... }: {
    home = {
      stateVersion = "23.05";
      packages = with pkgs; [
        pgcli
      ];
    };

    imports = [ ../modules/core ];
    local = {
      core.gui.enable = true;
    };
  };
}

