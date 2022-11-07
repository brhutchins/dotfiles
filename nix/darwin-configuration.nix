{ config, pkgs, lib,... }:

let
  yabai = pkgs.yabai.overrideAttrs (old: rec {
    version = "5.0.1";
    src = builtins.fetchTarball {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
      sha256 = "03kkjgq1kdaic7hbqhlgmr6vcvcdpsyivdh87492sgp5l71i0hvl";
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
  emacs-mac = ((pkgs.emacsPackagesFor pkgs.emacsNativeComp).emacsWithPackages (epkgs: [
        epkgs.vterm
  ])).overrideAttrs (super: {
    patches = [
      (pkgs.fetchpatch {
        name = "fix-window-role.patch";
        url = "https://raw.githubusercontent.com/d12frosted/homebrew-emacs-plus/master/patches/emacs-28/fix-window-role.patch";
        sha256 = "0c41rgpi19vr9ai740g09lka3nkjk48ppqyqdnncjrkfgvm2710z";
      })
    ];
  });

in
{
  imports = [ <home-manager/nix-darwin> ];

  nixpkgs.config.allowUnfree = true;

  nix.package = pkgs.nixFlakes;
  nix.extraOptions =
    lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

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
      iterm2
      emacsMacport
      bitwarden
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
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "09m6dpkzp4qhmva48czrb3i5j0lxsar08aly4kn14b451y6yv57g";
    }))
  ];


  users.users.barnaby = {
    name = "barnaby";
    home = "/Users/barnaby";
  };

  home-manager.users.barnaby = { pkgs, ... }: {
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
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
    };
    extraConfig = ''
      yabai -m rule --add app="^Digital Colou?r Meter$" manage=off
      yabai -m rule --add app="^About$" manage=off
      yabai -m rule --add app="^Contacts$" manage=off
      yabai -m rule --add app="^Installer$" manage=off
      yabai -m rule --add app="^System Preferences$" manage=off
      yabai -m rule --add app="^[Ee]macs$" manage=on
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
