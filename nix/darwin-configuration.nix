{ config, pkgs, lib,... }:

let
  yabai = pkgs.yabai.overrideAttrs (old: rec {
    version = "3.3.10";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "sha256:1z95njalhvyfs2xx6d91p9b013pc4ad846drhw0k5gipvl03pp92";
    };

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/share/man/man1/
      cp ./bin/yabai $out/bin/yabai
      cp ./doc/yabai.1 $out/share/man/man1/yabai1
    '';
  });
  hammerspoon = pkgs.callPackage /Users/barnaby/.dotfiles/nix/packages/hammerspoon {  };
  bitwarden = pkgs.callPackage /Users/barnaby/.dotfiles/nix/packages/bitwarden {  };
in
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
      pkgs.alacritty
      pkgs.iterm2
      bitwarden
      hammerspoon
      yabai
    ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  users.users.barnaby = {
    name = "barnaby";
    home = "/Users/barnaby";
  };

  home-manager.users.barnaby = { pkgs, ... }: {
    home.file.".config/home.nix".source = builtins.toPath "${config.users.users.barnaby.home}/.dotfiles/nix/home-manager/machines/darwin-hubs.nix";

    imports = [ ./test.nix ];

    home.packages = with pkgs; [ ];
  };

  services.yabai = {
    enable = true;
    package = yabai;
    config = {
      window_placement = "second_child";
      window_border = "off";
      layout = "bsp";
      top_padding = "08";
      bottom_padding = "08";
      left_padding = "12";
      right_padding = "12";
      window_gap = "04";

      window_opacity = "on";
      active_window_opacity = "1.0";
      normal_window_opacity = "0.9";
    };
  };

  services.skhd = {
    enable = true;
    
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog

  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in lib.mkForce ''
    # Set up applications.
    echo "setting up ~/Applications..." >&2

    rm -rf ~/Applications/Nix\ Apps
    mkdir -p ~/Applications/Nix\ Apps

    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
        while read src; do
          /bin/cp -cr "$src" ~/Applications/Nix\ Apps
        done
  '';


  system.stateVersion = 4;
}
