{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "bak";

  home-manager.users.barnaby = { pkgs, ... }: {
    home = {
      stateVersion = "23.05";
      packages = with pkgs; [
        unstable.colima
        docker
      ];
    };

    imports = [ ../modules/core ];
    local = {
      core.gui.enable = true;
    };
  };
}

