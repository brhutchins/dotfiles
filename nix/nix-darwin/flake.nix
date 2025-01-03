{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, ... }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      environment.variables = {
        EDITOR = "nvim";
      };

      system.defaults = {
        NSGlobalDomain = {
          _HIHideMenuBar = true;
          "com.apple.mouse.tapBehavior" = 1;
        };
        dock = {
          appswitcher-all-displays = true;
          autohide = true;
          mru-spaces = false;
        };
        finder = {
          AppleShowAllExtensions = true;
          CreateDesktop = false;
          FXDefaultSearchScope = "SCcf";
          FXPreferredViewStyle = "clmv";
          ShowPathbar = true;
        };
        trackpad = {
          Dragging = true;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
        };
      };

      services.yabai = {
        enable = true;
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
          yabai -m rule --add app="^System Settings$" manage=off
          yabai -m rule --add app="^[Ee]macs$" manage=on
          yabai -m rule --add app="^Little Arc —" manage=off
        '';
            };

      services.skhd = {
        enable = true;
        skhdConfig = ''
        # focus window
        hyper - left : yabai -m window --focus west
        hyper - right : yabai -m window --focus east
        hyper - down : yabai -m window --focus south
        hyper - up : yabai -m window --focus north

        # swap managed window
        shift + cmd - left : yabai -m window --swap west
        shift + cmd - right : yabai -m window --swap east
        shift + cmd - down : yabai -m window --swap south
        shift + cmd - up : yabai -m window --swap north

        # move managed window
        shift + alt + cmd - left : yabai -m window --warp west
        shift + alt + cmd - right : yabai -m window --warp east
        shift + alt + cmd - down : yabai -m window --warp south
        shift + alt + cmd - up : yabai -m window --warp north

        # make floating window fill screen
        hyper - f : yabai -m window --grid 1:1:0:0:1:1

        # fast focus desktop
        # cmd + alt - x : yabai -m space --focus recent
        hyper - 1 : yabai -m space --focus 1
        hyper - 2 : yabai -m space --focus 2
        hyper - 3 : yabai -m space --focus 3
        hyper - 4 : yabai -m space --focus 4
        hyper - 5 : yabai -m space --focus 5
        hyper - 6 : yabai -m space --focus 6
        hyper - 7 : yabai -m space --focus 7
        hyper - 8 : yabai -m space --focus 8
        hyper - 9 : yabai -m space --focus 9

        # send window to desktop and follow focus
        shift + ctrl + cmd - right : yabai -m window --space next; yabai -m space --focus next
        shift + ctrl + cmd - left : yabai -m window --space prev; yabai -m space --focus prev
        ctrl + cmd - 1 : yabai -m window --space 1; yabai -m space --focus 1
        ctrl + cmd - 2 : yabai -m window --space 2; yabai -m space --focus 2
        ctrl + cmd - 3 : yabai -m window --space 3; yabai -m space --focus 3
        ctrl + cmd - 4 : yabai -m window --space 4; yabai -m space --focus 4
        ctrl + cmd - 5 : yabai -m window --space 5; yabai -m space --focus 5
        ctrl + cmd - 6 : yabai -m window --space 6; yabai -m space --focus 6
        ctrl + cmd - 7 : yabai -m window --space 7; yabai -m space --focus 7
        ctrl + cmd - 8 : yabai -m window --space 8; yabai -m space --focus 8
        ctrl + cmd - 9 : yabai -m window --space 9; yabai -m space --focus 9

        # focus monitor
        hyper - r : yabai -m display --focus recent

        # send window to monitor and follow focus
        hyper - m : yabai -m window --display recent; yabai -m display --focus recent

        # move floating window
        # shift + ctrl - a : yabai -m window --move rel:-20:0
        # shift + ctrl - s : yabai -m window --move rel:0:20

        # increase window size
        # shift + alt - a : yabai -m window --resize left:-20:0
        # shift + alt - w : yabai -m window --resize top:0:-20

        # decrease window size
        # shift + cmd - s : yabai -m window --resize bottom:0:-20
        # shift + cmd - w : yabai -m window --resize top:0:20

        # set insertion point in focused container
        # ctrl + alt - h : yabai -m window --insert west

        # toggle window zoom
        # alt - d : yabai -m window --toggle zoom-parent
        # alt - f : yabai -m window --toggle zoom-fullscreen

        # toggle window split type
        # alt - e : yabai -m window --toggle split

        # float / unfloat window and center on screen
        hyper - space : yabai -m window --toggle float;\
            yabai -m window --grid 4:4:1:1:2:2

        # toggle sticky(+float), topmost, picture-in-picture
        # alt - p : yabai -m window --toggle sticky;\
        #           yabai -m window --toggle topmost;\
        #           yabai -m window --toggle pip

        # switch tiling mode for screen
        hyper - i : yabai -m config --space mouse layout bsp
        hyper - o : yabai -m config --space mouse layout stack
        hyper - p : yabai -m config --space mouse layout float

        # open stuff
        hyper - return : open -a wezterm.app
        hyper - g : open -a Finder.app
        hyper - 0x1B : open -a dmenu-mac.app

        # equalize size of windows
        hyper - 0 : yabai -m space --balance

        # Toggle split for focused window
        hyper - v : yabai -m window --toggle split

        # toggle border (useful for Safari fullscreen video with yabai…)
        hyper - h : yabai -m window --toggle border

        # Focus window up/down in stack
        hyper - j : yabai -m window --focus stack.next
        hyper - k : yabai -m window --focus stack.prev

        # Flip tree within current space
        hyper - 0x21 : yabai -m space --mirror y-axis
        hyper - 0x1E : yabai -m space --mirror x-axis
        hyper - 0x2A : yabai -m space --rotate 90


        # Add the active window  to the window or stack to the {direction}
        # Note that this only works when the active window does *not* already belong to a stack
        cmd + ctrl - left  : yabai -m window west --stack $(yabai -m query --windows --window | jq -r '.id')
        cmd + ctrl - down  : yabai -m window south --stack $(yabai -m query --windows --window | jq -r '.id')
        cmd + ctrl - up    : yabai -m window north --stack $(yabai -m query --windows --window | jq -r '.id')
        cmd + ctrl - right : yabai -m window east --stack $(yabai -m query --windows --window | jq -r '.id')

        '';
      };

      services.karabiner-elements.enable = true;

      services.tailscale.enable = true;

      homebrew = {
        enable = true;
        casks = [
          "hammerspoon"
          "raycast"
        ];
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true;  # default shell on catalina
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 4;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.barnaby.home = "/Users/barnaby";
    };
    work-config = { pkgs, ... }: {
      homebrew.casks = [
        "slack"
        "1password-cli"
      ];
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."PLN-JGY4PVV0H0" = nix-darwin.lib.darwinSystem {
      modules = [
      configuration
      work-config
      home-manager.darwinModules.home-manager
      ../home-manager/machines/darwin-hubs-2.nix
      ];
      specialArgs = { inherit inputs; };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."PLN-JGY4PVV0H0".pkgs;
  };
}
