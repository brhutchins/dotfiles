{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "barnaby";
  home.homeDirectory = "/home/barnaby";

  # Packages to install
  home.packages = with pkgs; [
    tmux
    pure-prompt
    zoxide
    tldr
    fd
    bat
    ripgrep
    fzf
    htop
    zenith
    git
    bitwarden
    playerctl
    neofetch
    alpine
    unzip
    ispell
    mosh

    # Language servers
    rnix-lsp
    haskell-language-server

    # nix-specific
    nix-prefetch-scripts

    # GUI
    kitty
    swaylock
    swayidle
    wl-clipboard
    mako
    bemenu
    waybar
    pavucontrol
    jq
    libappindicator-gtk3
    alacritty
    hicolor-icon-theme
    papirus-icon-theme
    zathura
    brave
    firefox-wayland
    vieb
    google-chrome-beta
    libnotify

    ## Screen sharing
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk

    # Communication
    zoom-us
    teams
    obs-studio

    # Fonts
    (nerdfonts.override { fonts = [ "Hasklig" "IBMPlexMono"]; })
    hasklig
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inter
    font-awesome
  ];

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    nix-direnv.enableFlakes = true;
  };

  programs.zsh = {
    enable = true;
    autocd = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    shellAliases = {
    };

    initExtra = ''
    # Set prompt
    autoload -U promptinit && promptinit && prompt pure

    # zoxide
    eval "$(zoxide init zsh)"
    '';
  };

  # omz
  programs.zsh.oh-my-zsh = {
    enable = true;
  };

  programs.nix-index.enable = true;

  # Lorri (nix-shell/direnv)
  services.lorri.enable = true;

  programs.git = {
    enable = true;
    userName = "brhutchins";
    userEmail = "bhutchins@gmail.com";
  };

  programs.gh = {
    enable = true;
    settings.gitProtocol = "ssh";
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs.neovim = {
    enable = true;
    plugins = with pkgs.vimPlugins;
      let
        kommentary = pkgs.vimUtils.buildVimPlugin {
          pname = "kommentary";
          version = "a";
          src = pkgs.fetchFromGitHub {
            owner = "b3nj5m1n";
            repo = "kommentary";
            rev = "8f1cd74ad28de7d7c4fda5d8e8557ff240904b42";
            sha256 = "0avd7v0nzz31nf5vj29npw5g7c2rrlirvkyd042qlh5y2vas7b2g";
          };
        };
      in [
        haskell-vim
        # indent-blankline-nvim
        kommentary
        lualine-nvim
        nvim-autopairs
        nvim-compe
        nvim-lightbulb
        nvim-lspconfig
        nvim-treesitter
        nvim-web-devicons
        oceanic-next
        plenary-nvim
        popup-nvim
        purescript-vim
        vim-python-pep8-indent
        telescope-nvim
        trouble-nvim
        vim-gitgutter
        vim-lion
        vim-nix
        vim-sneak
        vim-surround
        vim-vsnip
        vim-vsnip-integ
      ];

    extraConfig = ''
      lua << EOF

      -- Options
      require("options")

      -- Package config
      require("packages.config")

      -- Theme
      require("theme")

      -- Keybindings
      require("keybindings")

      -- LSP
      require("lsp")

      -- Treesitter
      require("treesitter-config")

      -- Whitespace
      require("whitespace")

      -- Terminal
      require("terminal")

      EOF
    '';
  };

  # Raw configuration files
  # nvim
  home.file.".config/nvim/lua".source = ./nvim/lua;

  # kitty
  home.file.".config/kitty/theme.conf".source = ./kitty/themes/oceanic-next.conf;

  home.sessionPath = [
    "$HOME/.emacs.d/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    GTK_THEME = "Adwaita:dark";
  };

  # n3
  programs.nnn = {
    enable = true;
    package = pkgs.nnn.override ({ withNerdIcons = true; });
    bookmarks = {
      h = "~";
      d = "~/Development";
    };
  };

  # Sway
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
              timeout 600 "swaymsg 'output * dpms off'" \
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
        size = 9.0;
      };

      # Borders
      window.hideEdgeBorders = "smart";

      # Gaps
      gaps = null;

      input = {
        "1149:8264:Primax_Kensington_Eagle_Trackball" = { left_handed = "enable"; };
      };

      keybindings = let cfg = config.wayland.windowManager.sway.config; in {
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
  };

  # Waybar
  home.file = {
    ".config/waybar/config".source = ./waybar/config;
    ".config/waybar/style.css".source = ./waybar/style.css;
  };

  # Weather module
  home.file = {
    ".config/wayther/config.json".source = ./wayther/config.json;
  };

  # Swaylock
  home.file = {
    ".config/swaylock/config".source = ./swaylock/config;
  };

  # Swaynag
  home.file = {
    ".config/swaynag/config".source = ./swaynag/config;
  };

  # GTK
  gtk = {
    enable = true;
    font.package = pkgs.inter;
    font.name = "Inter Medium";
    font.size = 9;
    theme.name = "Adwaita:dark";
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  services.gammastep = {
    enable = true;
    provider = "geoclue2";
  };

  programs.mako = {
    enable = true;
    backgroundColor = "#161916EE";
    borderSize = 0;
    borderRadius = 4;
    font = "Inter Light 10";
    progressColor = "source #5fb3b3FF";
    textColor = "#ddddddFF";
    iconPath = "${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark/";
    padding = "8";
    width = 280;
    extraConfig = ''
      [urgency=low]
      background-color=#161916DD
      text-color=#aaaaaaEE
    '';
  };

  # kitty
  programs.kitty = {
    enable = true;
    font.name = "Hasklug Nerd Font";
    font.size = 10;

    keybindings = {
      "kitty_mod+equal" = "change_font_size all +1.0";
      "kitty_mod+minus" = "change_font_size all -1.0";
      "kitty_mod+backspace" = "change_font_size all 0.0";
    };
    
    settings = {
      mouse_hide_wait = "3.0";
      # Bell
      enable_audio_bell = "no";
      visual_bell_duration = "0.1";
      bell_on_tab = "yes";
      # Window layout
      window_border_width = "1.0px";
      draw_minimal_borders = "yes";
      window_margin_width = 0;
      window_padding_width = 10;
      active_border_color = "#d8dee9";
      inactive_border_color = "#555555";
      inactive_text_alpha = "0.9";
      hide_window_decorations = "no";
      confirm_os_window_close = 1;
      # OS-specific
      macos_titlebar_color = "background";
      macos_option_as_alt = "left";
      # Tab bar
      tab_bar_edge = "top";
      tab_bar_margin_width = "8.0";
      tab_bar_margin_height = "5.0 0.0";
      tab_bar_style = "separator";
      tab_separator = "\"   \"";
      tab_title_template = "\"{index}: {title[:21]}\"";
      tab_activity_symbol = "⋮";
      active_tab_font_style = "bold-italic";
      inactive_tab_font_style = "bold";

    };
    # Colour scheme
    ## Applied through file
    extraConfig = builtins.readFile ./kitty/themes/oceanic-next.conf;
  };

  # firefox
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      forceWayland = true;
    };
  };

  # Fonts
  fonts.fontconfig.enable = true;

  # environment.systemPackages = with pkgs; [ wl-clipboard ];

  # This value determines the Home Manager release that your
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "21.11";
}
