{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    ../../linux/gui
  ];

  config = {
    # If we want Sway, we want the other gui stuff
    local.linux.gui.enable = true;

    #####
    #
    # Extra packages
    # (See ../../linux/gui/ for general Wayland dependencies)

    home.packages = with pkgs; [
      bemenu
      mako
      swayidle
      swaylock
      waybar
    ];

    #####
    #
    # Sway config

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "sway";
    };

    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
      config = {
        modifier = "Mod4";
        terminal = "kitty";
        menu = ''
          bemenu-run --fn 'Inter Medium 10' \
          --nb '#161916' --nf '#82858c' \
          --fb '#161916' --ff '#5fb3b3' \
          --hb '#5fb3b3' --hf '#161916' \
          --tb '#161916' --tf '#5fb3b3' \
          -p '⋮' \
          -i \
          -b
        '';
        startup = [
          { command = "waybar"; }
          { command = "mako"; }
          { command = ''
              exec swayidle -w \
                timeout 900 "swaymsg 'output * dpms off'" \
                timeout 1200 "swaylock -f" \
                resume "swaymsg 'output * dpms on'"
            ''; }
        ];

        # Workspaces
        defaultWorkspace = "workspace number 1";

        # Background
        output."*".bg = "#1b2b34 solid_color";

        fonts = {
          names = [ "inter" ];
          style = "medium";
          size = 10.0;
        };

        # Borders
        window.hideEdgeBorders = "smart";

        # Gaps
        gaps = null;

        input = {
          "1149:8264:Primax_Kensington_Eagle_Trackball" = { left_handed = "enable"; };
        };

        keybindings =
          let
            cfg = config.wayland.windowManager.sway.config;
            monitor = { main = "HDMI-A-1"; };
          in {
          # Basics
          "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
          "${cfg.modifier}+Shift+q" = "kill";
          "${cfg.modifier}+d" = "exec ${cfg.menu}";
          "${cfg.modifier}+Shift+c" = "reload";
          "${cfg.modifier}+Shift+e" = ''
            exec swaynag \
            -t warning \
            -m 'Exit Sway?' \
            -b 'Yes' 'swaymsg exit'
          '';

          # Multimedia keys
          "XF86AudioMute" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "XF86AudioRaiseVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5%";
          "XF86AudioLowerVolume" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5%";
          "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
          "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";

          # Moving around
          ## Focus
          "${cfg.modifier}+Left" = "focus left";
          "${cfg.modifier}+Down" = "focus down";
          "${cfg.modifier}+Up" = "focus up";
          "${cfg.modifier}+Right" = "focus right";

          "${cfg.modifier}+a" = "focus parent";

          ## Move the focused window
          "${cfg.modifier}+Shift+Left" = "move left";
          "${cfg.modifier}+Shift+Down" = "move down";
          "${cfg.modifier}+Shift+Up" = "move up";
          "${cfg.modifier}+Shift+Right" = "move right";

          ## Workspaces
          ### Focus
          "${cfg.modifier}+1" = "workspace number 1";
          "${cfg.modifier}+2" = "workspace number 2";
          "${cfg.modifier}+3" = "workspace number 3";
          "${cfg.modifier}+4" = "workspace number 4";
          "${cfg.modifier}+5" = "workspace number 5";
          "${cfg.modifier}+6" = "workspace number 6";
          "${cfg.modifier}+7" = "workspace number 7";
          "${cfg.modifier}+8" = "workspace number 8";
          "${cfg.modifier}+9" = "workspace number 9";
          "${cfg.modifier}+0" = "workspace number 10";

          ### Move
          "${cfg.modifier}+Shift+1" = "move to workspace number 1; workspace number 1";
          "${cfg.modifier}+Shift+2" = "move to workspace number 2; workspace number 2";
          "${cfg.modifier}+Shift+3" = "move to workspace number 3; workspace number 3";
          "${cfg.modifier}+Shift+4" = "move to workspace number 4; workspace number 4";
          "${cfg.modifier}+Shift+5" = "move to workspace number 5; workspace number 5";
          "${cfg.modifier}+Shift+6" = "move to workspace number 6; workspace number 6";
          "${cfg.modifier}+Shift+7" = "move to workspace number 7; workspace number 7";
          "${cfg.modifier}+Shift+8" = "move to workspace number 8; workspace number 8";
          "${cfg.modifier}+Shift+9" = "move to workspace number 9; workspace number 9";
          "${cfg.modifier}+Shift+0" = "move to workspace number 10; workspace number 10";

          # Layout
          "${cfg.modifier}+e" = "layout toggle split";
          "${cfg.modifier}+s" = "layout stacking";
          "${cfg.modifier}+t" = "layout tabbed";
          "${cfg.modifier}+f" = "fullscreen toggle";
          "${cfg.modifier}+Control+space" = "floating toggle";

          # Scratchpad
          "${cfg.modifier}+Shift+minus" = "move window to scratchpad";
          "${cfg.modifier}+minus" = "scratchpad show";

          # Splits
          "${cfg.modifier}+b" = "splith";
          "${cfg.modifier}+v" = "splitv";

          # Resize mode
          "${cfg.modifier}+r" = "mode resize";

          # Waybar
          "${cfg.modifier}+space" = "exec pkill -SIGUSR1 waybar";

          # Notifications
          "${cfg.modifier}+x" = "exec makoctl dismiss";

          # Lock
          "${cfg.modifier}+Control+l" = "exec swaylock -f";

          # Sleep
          "${cfg.modifier}+Control+s" = "exec systemctl suspend -i && swaylock -f";

          # DPMS
          "${cfg.modifier}+Shift+o" = "exec swaymsg 'output * dpms off'";
          "${cfg.modifier}+Shift+Control+o" = "exec swaymsg 'output * dpms on'";

          # Screen rotation
          "${cfg.modifier}+Shift+r" = "exec swaymsg 'output ${monitor.main} transform 90'";
          "${cfg.modifier}+Control+Shift+r" = "exec swaymsg 'output ${monitor.main} transform 0'";


          # System shutdown/reboot
          "${cfg.modifier}+Control+Shift+s" = ''
              exec swaynag \
                -t warning \
                -m "Shut down system?" \
                -Z "Reboot" "reboot" \
                -Z "Shut down" "systemctl poweroff"
            '';

        };

        colors = {
          focused = rec {
            border = "#d8dee9";
            background = "#d8dee9";
            text = "#1b2b34";
            indicator = "#5fb3b3";
            childBorder = background;
          };
          focusedInactive = rec {
            border = "#555555";
            background = "#1b2b34";
            text = "#ffffff";
            indicator = "#5fb3b3";
            childBorder = background;
          };
          unfocused = rec {
            border = "#1b2b34";
            background = "#1b2b34";
            text = "#888888";
            indicator = "#292d2e";
            childBorder = background;
          };
          urgent = rec {
            border = "#C10004";
            background = "#900000";
            text = "#ffffff";
            indicator = "#900000";
            childBorder = background;
          };
        };

        window.commands = [
          # Zoom
          {
            command = "floating enable";
            criteria.title="^(Zoom|About)$";
          }
          {
            command = "floating enable, border none";
            criteria.title = "^zoom$";
          }

          # Generic Settings window
          ## Because zoom reports no app_id 😠
          ## And I guess it makes sense to float any window that's
          ## just called 'Settings'
          {
            command = "floating enable";
            criteria.title="^Settings$";
          }

          # Picture-in-Picture
          {
            command = "floating enable, border none, sticky enable";
            criteria.title = "^Picture-in-Picture$";
          }

          # pavucontrol
          {
            command = "floating enable";
            criteria.app_id = "pavucontrol";
          }
        ];


        bars = [];

      };

      swaynag = {
        enable = true;
        settings = {
          "<config>" = {
            font = "Inter Semibold 10";
          };

          warning = {
            background = "5fb3b3";
            border-bottom-size = "0";
            text = "161916ee";
            button-background = "5fb3b3";
            button-border-size = "0";
            button-text = "161916ee";
            button-gap = "0";
            button-margin-right = "8";
            button-padding = "8";
          };
        };
      };
    };

    # Waybar
    home.file = {
      ".config/waybar/config".source = ../../../waybar/config;
      ".config/waybar/style.css".source = ../../../waybar/style.css;
    };

    # Weather module
    home.file = {
      ".config/wayther/config.json".source = ../../../wayther/config.json;
    };

    # Swaylock
    home.file = {
      ".config/swaylock/config".source = ../../../swaylock/config;
    };
  };

}
