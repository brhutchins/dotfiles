{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    border-color = {
      active = "0xffff70b3";
      warning = "0xfffffd82";
      warning-2 = "0xfff5f100";
      warning-3 = "0xffB8B500";
      inactive = "0x00000000";
    };

    system = "aarch64-darwin";

    lib = nixpkgs.lib;

    configuration = { pkgs, ... }: {
      nixpkgs.overlays = [
        (self: super: {
          karabiner-elements = super.karabiner-elements.overrideAttrs (old: {
            version = "14.13.0";

            src = super.fetchurl {
              inherit (old.src) url;
              hash = "sha256-gmJwoht/Tfm5qMecmq1N6PSAIfWOqsvuHU8VDJY8bLw=";
            };
          });
        })
      ];

      nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
             "raycast"
           ];

      nix.enable = false;

      environment.systemPackages = with pkgs;
        [ neovim
          raycast
        ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      environment.variables = {
        EDITOR = "nvim";
      };

      system.primaryUser = "barnaby";

      system.defaults = {
        NSGlobalDomain = {
          _HIHideMenuBar = true;
          "com.apple.mouse.tapBehavior" = 1;
        };
        dock = {
          appswitcher-all-displays = true;
          autohide = true;
          mru-spaces = false;
          expose-group-apps = true;
        };
        finder = {
          AppleShowAllExtensions = true;
          CreateDesktop = false;
          FXDefaultSearchScope = "SCcf";
          FXPreferredViewStyle = "clmv";
          ShowPathbar = true;
        };
        trackpad = {
          Dragging = false;
          TrackpadRightClick = true;
          TrackpadThreeFingerDrag = true;
        };
      };

      services.aerospace = {
        enable = true;
        settings = {
          default-root-container-layout = "tiles";
          default-root-container-orientation = "auto";
          on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
          gaps = {
            outer.left = 10;
            outer.bottom = 10;
            outer.top = 10;
            outer.right = 10;
            inner.horizontal = 10;
            inner.vertical = 10;
          };
          key-mapping = {
            key-notation-to-key-code = {
              # Remap for Colemak.
              q = "q";
              w = "w";
              f = "e";
              p = "r";
              g = "t";
              j = "y";
              l = "u";
              u = "i";
              y = "o";
              semicolon = "p";
              leftSquareBracket = "leftSquareBracket";
              rightSquareBracket = "rightSquareBracket";
              backslash = "backslash";

              a = "a";
              r = "s";
              s = "d";
              t = "f";
              d = "g";
              h = "h";
              n = "j";
              e = "k";
              i = "l";
              o = "semicolon";
              quote = "quote";

              z = "z";
              x = "x";
              c = "c";
              v = "v";
              b = "b";
              k = "n";
              m = "m";
              comma = "comma";
              period = "period";
              slash = "slash";
            };
          };

          mode.main.binding = {
            # Workspaces.
            cmd-ctrl-alt-shift-1 = "workspace 1";
            cmd-ctrl-alt-shift-2 = "workspace 2";
            cmd-ctrl-alt-shift-3 = "workspace 3";
            cmd-ctrl-alt-shift-4 = "workspace 4";
            cmd-ctrl-alt-shift-5 = "workspace 5";
            cmd-ctrl-alt-shift-a = "workspace Audio";
            cmd-ctrl-alt-shift-s = "workspace Communications";
            cmd-ctrl-alt-shift-m = "workspace Meeting";
            cmd-ctrl-alt-shift-u = "workspace Utilities";
            cmd-ctrl-alt-shift-h = "workspace Home";

            alt-shift-w = "mode workspace";
            cmd-ctrl-alt-shift-semicolon = [ "mode navigation" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.warning}" ];

          };

          mode.navigation.binding = {
            esc = ["mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];

            cmd-ctrl-alt-shift-semicolon =[ "mode workspace" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.warning-2}" ];

            h = "focus left";
            j = "focus down";
            k = "focus up";
            l = "focus right";

            shift-h = "move left";
            shift-j = "move down";
            shift-k = "move up";
            shift-l = "move right";

            alt-shift-h = [ "join-with left" ];
            alt-shift-j =[ "join-with up" ];
            alt-shift-k =[ "join-with down" ];
            alt-shift-l =[ "join-with right" ];

            minus = "resize smart -50";
            equal = "resize smart +50";

            space = [ "fullscreen" ];
          };

          mode.workspace.binding = {
            esc = ["mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];

            cmd-ctrl-alt-shift-semicolon =[ "mode service" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.warning-3}" ];

            "1" = [ "workspace 1" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "2" = [ "workspace 2" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "3" = [ "workspace 3" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "4" = [ "workspace 4" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "5" = [ "workspace 5" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "a" = [ "workspace Audio" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "s" = [ "workspace Communications" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "m" = [ "workspace Meeting" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "u" = [ "workspace Utilities" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            "h" = [ "workspace Home" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];

            alt-1 =[ "move-node-to-workspace 1" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-2 =[ "move-node-to-workspace 2" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-3 =[ "move-node-to-workspace 3" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-4 =[ "move-node-to-workspace 4" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-5 =[ "move-node-to-workspace 5" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-a =[ "move-node-to-workspace Audio" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-s =[ "move-node-to-workspace Communications" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-m =[ "move-node-to-workspace Meeting" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-u =[ "move-node-to-workspace Utilities" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
            alt-h =[ "move-node-to-workspace Home" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];

            tab = [ "move-workspace-to-monitor --wrap-around next" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];
          };

          mode.service.binding = {
            esc = ["mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ];

            r = ["flatten-workspace-tree" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ]; # reset layout
            space = ["layout floating tiling" "mode main" "exec-and-forget ${pkgs.jankyborders}/bin/borders active_color=${border-color.active}" ]; # Toggle between floating and tiling layout

            slash = "layout tiles horizontal vertical";
            comma = "layout accordion horizontal vertical";
          };

          workspace-to-monitor-force-assignment = {
            "1" = "main";
            "2" = "main";
            "Communications" = "built-in";
            "Meeting" = "built-in";
          };

          on-window-detected = [
            {
              "if".app-id = "com.apple.Music";
              run = "move-node-to-workspace Audio";
            }
            {
              "if".app-id = "com.apple.audio.AudioMIDISetup";
              run = "move-node-to-workspace Audio";
            }
          ];
        };
      };

      services.jankyborders = {
        enable = true;
        inactive_color = border-color.inactive;
        active_color = border-color.active;
        width = 8.5;
      };

      # services.karabiner-elements.enable = true;

      services.tailscale = {
        enable = true;
        # overrideLocalDns = true;
      };

      homebrew = {
        enable = true;
        casks = [
          "ghostty"
          "raycast"
          "bitwarden"
          "karabiner-elements"
        ];
      };


      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      nix.settings.trusted-users = [ "barnaby" ];

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.barnaby.home = "/Users/barnaby";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MacMini
    darwinConfigurations."MacMini" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
	{
          home-manager.extraSpecialArgs = { inherit inputs system; };
        }
        ../home-manager/machines/darwin-personal.nix
      ];
      specialArgs = { inherit inputs system; };
    };
  };
}
