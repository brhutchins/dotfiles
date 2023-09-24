{ config
, pkgs
, lib
, ... }:

let
  yabai = pkgs.stdenvNoCC.mkDerivation rec {
    inherit (pkgs.darwin.apple_sdk.frameworks) Carbon Cocoa ScriptingBridge SkyLight;

    name = "yabai";
    pversion = "5.0.8";

    src = pkgs.fetchzip {
      url = "https://github.com/koekeishiya/yabai/releases/download/v${pversion}/yabai-v${pversion}.tar.gz";
      hash = "sha256-w4MTHHYWwBq0/WkemYIeV49aA/DzFxXITD8gF5St0Yo=";
    };

    nativeBuildInputs = with pkgs; [
      installShellFiles
    ];

    dontConfigure = true;
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out
      cp -r ./bin $out
      installManPage ./doc/yabai.1

      runHook postInstall
    '';

    # src = builtins.fetchTarball {
    #   url = "https://github.com/koekeishiya/yabai/releases/download/v${version}/yabai-v${version}.tar.gz";
    #   sha256 = "sha256:11dimky2r0gskp8vniwjc4d70bpkkck5mnjwcbjxid2csykhrx8p";
    # };

    # nativeBuildInputs = [
    #   pkgs.installShellFiles
    # ];

    # dontBuild = true;
    # dontConfigure = true;

    # installPhase = ''
    #   runHook preInstall

    #   mkdir -p $out
    #   cp -r ./bin $out
    #   installManPage ./doc/yabai.1

    #   runHook postInstall
    # '';

    # # installPhase = ''
    # #   mkdir -p $out/bin
    # #   mkdir -p $out/share/man/man1/
    # #   cp ./bin/yabai $out/bin/yabai
    # #   cp ./doc/yabai.1 $out/share/man/man1/yabai1
    # # '';
    # src = pkgs.fetchFromGitHub {
    #   owner = "koekeishiya";
    #   repo = "yabai";
    #   rev = "v${pversion}";
    #   hash = "sha256-VahfeKYz/cATb0RF9QykngMtRpCh392jY8aJuggpqMU=";
    # };

    # nativeBuildInputs = with pkgs; [
    #   installShellFiles
    #   xcodebuild
    #   xxd
    # ];

    # buildInputs = [
    #   Carbon
    #   Cocoa
    #   ScriptingBridge
    #   SkyLight
    # ];

    # dontConfigure = true;
    # # enableParallelBuilding = true;

    # postPatch = ''
    #   # aarch64 code is compiled on all targets, which causes our Apple SDK headers to error out.
    #   # Since multilib doesnt work on darwin i dont know of a better way of handling this.
    #   substituteInPlace makefile \
    #     --replace "-arch arm64e" "" \
    #     --replace "-arch arm64" "" \
    #     --replace "clang" "${pkgs.stdenv.cc.targetPrefix}clang"

    #   # `NSScreen::safeAreaInsets` is only available on macOS 12.0 and above, which frameworks arent packaged.
    #   # When a lower OS version is detected upstream just returns 0, so we can hardcode that at compiletime.
    #   # https://github.com/koekeishiya/yabai/blob/v4.0.2/src/workspace.m#L109
    #   substituteInPlace src/workspace.m \
    #     --replace 'return screen.safeAreaInsets.top;' 'return 0;'
    # '';

    # installPhase = ''
    #   runHook preInstall

    #   mkdir -p $out/{bin,share/icons/hicolor/scalable/apps}

    #   cp ./bin/yabai $out/bin/yabai
    #   cp ./assets/icon/icon.svg $out/share/icons/hicolor/scalable/apps/yabai.svg
    #   installManPage ./doc/yabai.1

    #   runHook postInstall
    # '';

  };
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

  # nix.package = pkgs.nixFlakes;
  nix.extraOptions =
    lib.optionalString (config.nix.package == pkgs.nixFlakes)
    "experimental-features = nix-command flakes";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs;
    [ vim
      amazon-ecr-credential-helper
      awscli
      aws-vault
      docker
      openssl
      bitwarden
      hammerspoon
    ];



  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "${builtins.getEnv "HOME"}/.dotfiles/nix/darwin-configuration.nix";

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  # environment.shells = [ pkgs.bashInteractive pkgs.zsh ];

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.bash.enable = true;
  # programs.fish.enable = true;

  environment.pathsToLink = [ "/share/bash-completion" ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      sha256 = "sha256:12dgyas7r3cmhip7rifzy3ydryl3gnkn39csywp7xriazpws5ms9";
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
