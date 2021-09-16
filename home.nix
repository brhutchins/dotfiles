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
    oh-my-zsh
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

    # Language servers
    rnix-lsp
    haskell-language-server
    nodePackages.purescript-language-server

    # nix-specific
    nix-prefetch-scripts

    # GUI
    kitty
    swaylock
    swayidle
    wl-clipboard
    mako
    bemenu
    alacritty
    hicolor-icon-theme
    zathura
    brave
    firefox-wayland
    vieb

    # Communication
    zoom-us
    teams
    obs-studio

    # Fonts
    hasklig
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    inter
  ];

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
    oh-my-zsh = {
        plugins = [
        "ssh-agent"
      ];
    };

    initExtra = ''
    # Set prompt
    autoload -U promptinit && promptinit && prompt pure

    # zoxide
    eval "$(zoxide init zsh)"
    '';
  };

  programs.git = {
    enable = true;
    userName = "brhutchins";
    userEmail = "bhutchins@gmail.com";
  };

  programs.gh = {
    enable = true;
    gitProtocol = "ssh";
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
            rev = "fe01018a490813a8d89c09947a7ca23fc0e9e728";
            sha256 = "06shsdv92ykf3zx33a7v4xlqfi6jwdpvv9j6hx4n6alk4db02kgd";
          };
        };
      in [
        nvim-lspconfig
        nvim-compe
        nvim-treesitter
        popup-nvim
        plenary-nvim
        telescope-nvim
        kommentary
        vim-lion
        nvim-autopairs
        vim-vsnip
        vim-vsnip-integ
        lualine-nvim
        nvim-web-devicons
        vim-sneak
        vim-surround
        vim-gitgutter
        haskell-vim
        vim-nix
        purescript-vim
        oceanic-next
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

  home.sessionVariables = { EDITOR = "nvim"; };

  # Sway
 
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      menu = ''
        bemenu-run --fn 'Inter Medium 10' \
        --nb '#1b2b34' --nf '#d8dee9' \
        --fb '#1b2b34' \
        --hb '#ec5f67' --hf '#1b2b34' \
        --tb '#1b2b34' --tf '#6699cc' \
        -p '⋮' \
        -i
      '';

      # Background
      output."*".bg = "#1b2b34 solid_color";

      fonts = {
        names = [ "inter" ];
        style = "medium";
        size = 10.0;
      };

      keybindings = let cfg = config.wayland.windowManager.sway.config; in {
        # Basics
        "${cfg.modifier}+Return" = "exec ${cfg.terminal}";
        "${cfg.modifier}+Shift+q" = "kill";
        "${cfg.modifier}+d" = "exec ${cfg.menu}";
        "${cfg.modifier}+Shift+c" = "reload";
        "${cfg.modifier}+Shift+e" = "exec swaynag -t warning -m 'Exit Sway?' -b 'Yes' 'swaymsg exit'";
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

        # Splits
        "${cfg.modifier}+b" = "splith";
        "${cfg.modifier}+v" = "splitv";

        # Resize mode
        "${cfg.modifier}+r" = "mode resize";

        # Lock
        "${cfg.modifier}+Control+l" = "exec swaylock -f -u -c 000000";

        # Sleep
        "${cfg.modifier}+Control+s" = "exec systemctl suspend -i && swaylock -f -c 000000";

      };

      colors = {
        focused = rec {
          border = "#ff0088 ";
          background = "#ff0088 ";
          text = "#00BAA7 ";
          indicator = "#00DA8E";
          childBorder = background;
        };
        focusedInactive = rec {
          border = "#555555";
          background = "#5F676A";
          text = "#ffffff";
          indicator = "#484e50";
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
        {
          command = "floating enable";
          criteria.app_id = "zoom";
          criteria.title="^(Zoom|About)$";
        }

        {
          command = "floating enable";
          criteria.app_id = "zoom";
          criteria.title="Settings";
        }
        {
          command = "floating_minimum_size 960 x 700";
          criteria.app_id = "zoom";
          criteria.title="Settings";
        }
      ];


      bars = [
        {
          position = "top";
          fonts = {
            names = [ "Inter" ];
            style = "Medium";
            size = 9.0;
          };

          colors = {
            background = "#1b2b34";

            focusedWorkspace = {
              background = "#1b2b34";
              border = "#1b2b34";
              text = "#ffffff";
            };

            inactiveWorkspace = {
              background = "#1b2b34";
              border = "#1b2b34";
              text = "#56737e";
            };

            urgentWorkspace = {
              background = "#5fB3B3";
              border = "#1b2b34";
              text = "#ffffff";
            };

            bindingMode = {
              background = "#5fB3B3";
              border = "#1b2b34";
              text = "#ffffff";
            };
          };

          statusCommand = "exec /nix/store/143m3a06vk1qcbr2lvszz24bibblmaq3-i3status-2.13/bin/i3status";

          mode = "hide";

        }
      ];

    };
  };

  # GTK
  gtk = {
    enable = true;
    font.name = "Inter Medium";
    font.size = 9;
  };

  # kitty
  programs.kitty = {
    enable = true;
    font.name = "Hasklig";
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
      active_border_color = "#ff0088";
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
