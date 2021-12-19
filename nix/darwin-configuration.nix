{ config, pkgs, lib,... }:

let
  yabai = pkgs.yabai.overrideAttrs (old: rec {
    version = "4.0.0";
    src = builtins.fetchTarball {
      # url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      url = "https://github.com/koekeishiya/yabai/files/7570537/yabai-v4.0.0.tar.gz";
      sha256 = "sha256:1kpgnc2fwf45zrnw54vg1yfqvpg2m6w191lpvvhwsx6f5410b92y";
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
  dmenu-mac = pkgs.callPackage /Users/barnaby/.dotfiles/nix/packages/dmenu-mac {  };
in
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ vim
      alacritty
      amazon-ecr-credential-helper
      awscli
      aws-vault
      docker
      docker-compose
      openssl
      # python39Full
      iterm2
      # slack
      # Emacs
      ((emacsPackagesNgGen emacsPgtkGcc).emacsWithPackages (epkgs: [
        epkgs.vterm
      ]))
      bitwarden
      # dmenu-mac
      hammerspoon
      yabai
    ];



  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "${builtins.getEnv "HOME"}/.dotfiles/nix/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  # programs.fish.enable = true;

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/90e1419696ac7f13f2a5be35fddd85af8068cabb.tar.gz;
      sha256 = "14chrj7f5la6na0gcbhwp0h4rwjp5xzvl7b7srl0n6h1lrrag2cq";
    }))
  ];


  users.users.barnaby = {
    name = "barnaby";
    home = "/Users/barnaby";
  };

  home-manager.users.barnaby = { pkgs, ... }: {
    # home.file.".config/home.nix".source = builtins.toPath "${config.users.users.barnaby.home}/.dotfiles/nix/home-manager/machines/darwin-hubs.nix";

    imports = [ ./home-manager/machines/darwin-hubs.nix ];

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
      window_gap = "10";
      mouse_follows_focus = "on";
    };
    extraConfig = ''
      yabai -m rule --add app="^Digital Colou?r Meter$" manage=off
      yabai -m rule --add app="^About$" manage=off
      yabai -m rule --add app="^Contacts$" manage=off
      yabai -m rule --add app="^Installer$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
    '';
  };

  services.skhd = {
    enable = true;
  };

  services.lorri.enable = true;

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
