{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  home-manager.users.barnaby = { pkgs, ... }: {
    home = {
      stateVersion = "23.05";
      packages = with pkgs; [
        unstable.colima
        docker_29
        docker-buildx
        pgcli
        zed-editor
      ];
    };

    imports = [ ../modules/core ];
    local = {
      core.gui.enable = true;
      core.zscaler.enable = true;
      core.work.enable = true;
    };
  };
}
