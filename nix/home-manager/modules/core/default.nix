{ config, lib, pkgs, system, ... }:

with lib;
with pkgs;

let
  cfg = config.local.core;
  data = import ../data;
  isLinux = lib.strings.hasSuffix "linux" system;
  isDarwin = lib.strings.hasSuffix "darwin" system;
  gui-packages = {
    firefox = if isLinux then firefox-wayland else firefox;
    kitty = ../terminals/kitty;
  };
  mosh-git = mosh.overrideAttrs (super: {
    version = "git";
    src = fetchFromGitHub {
      owner = "mobile-shell";
      repo = "mosh";
      rev = "2f90add";
      sha256 = "sha256-0Ofdzym7CFiU6uG5yiSF+lIDBYYOiIVu+5tyIYHS6kk=";
    };
    patches = [];
    postPatch = ''
      substituteInPlace scripts/mosh.pl \
      --subst-var-by ssh "${openssh}/bin/ssh" \
      --subst-var-by mosh-client "$out/bin/mosh-client"
    '';
    configureFlags = [];
  });
  zellij-head = zellij.overrideAttrs (old: rec {
    # version = "2022-07-16";
    # src = fetchFromGitHub {
    #   owner  = "zellij-org";
    #   repo = "zellij";
    #   rev = " b78ecdf";
    #   sha256 = "";
    # };
    # cargoDeps = old.cargoDeps.overrideAttrs (_: {
    #   inherit src;
    #   outputHash = "";
    # });
  });
  p = {
    utils = [
      bat
      btop
      fd
      fzf
      git
      git-filter-repo
      gnupg
      hey
      htop
      httpie
      jq
      nh
      nodejs_24
      neofetch
      pandoc
      procps
      ripgrep
      slides
      tailscale
      tldr
      unzip
      xh
      zoxide
    ];
    languages = [
      agda
    ];
    languageServers = [
      nil
      nixd
    ];
    nixSpecific = [
      nix-prefetch-scripts
    ];
    fonts = [
      nerd-fonts.symbols-only
      hasklig
      ibm-plex
      inter
      emacs-all-the-icons-fonts
    ];
    gui = with gui-packages; [
      anki-bin
    ];
  };
  mkGui = lists.optionals cfg.gui.enable;
  sessionVariablesForLinux = mkIf isLinux {
    MOZ_ENABLE_WAYLAND = 1;
    XDG_CURRENT_DESKTOP = "sway"; 
  };
  # On Darwin with Zscaler, point SSL tooling at the combined CA bundle built
  # by the nix-darwin activation script (includes the Zscaler root CA).
  # The file check means this is a no-op on machines without Zscaler.
  zscalerBundle = "/etc/ssl/certs/ca-bundle-with-zscaler.crt";
  sessionVariablesForDarwin = lib.optionalAttrs (isDarwin && builtins.pathExists zscalerBundle) {
    NIX_SSL_CERT_FILE = zscalerBundle;
    SSL_CERT_FILE = zscalerBundle;
  };

  # Fetch zjstatus at build time via nix so zellij never needs to download it
  # at runtime (which fails because zellij's rustls doesn't trust Zscaler's CA).
  zjstatus = pkgs.fetchurl {
    url = "https://github.com/dj95/zjstatus/releases/download/v0.22.0/zjstatus.wasm";
    hash = "sha256-TeQm0gscv4YScuknrutbSdksF/Diu50XP4W/fwFU3VM=";
  };
in
{
  imports = [
    ../darwin/core
    ../editors/doom
    ../editors/helix
    ../editors/nvim
    ../terminals/kitty
    ../terminals/wezterm
    ../linux/gui
  ];

  options.local.core = {
    gui.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether we're installing core gui apps (e.g., Firefox)";
    };

    work.enable = mkOption {
      type = types.bool;
      default = false;
      description = "If this is a work setup, we'll, e.g., use work email for Git.";
    };
  };

  config = {

    # nixpkgs.allowUnfree = true;

    home.packages =
         p.utils
      ++ p.languages
      ++ p.languageServers
      ++ p.nixSpecific
      ++ mkGui p.fonts
      ++ mkGui p.gui;

    home.shellAliases = {
      vim = "nvim";
    };

    #####
    #
    # Nix

    programs.nix-index.enable = true;


    #####
    #
    # zsh

    programs.zsh = {
      enable = true;
      autocd = true;
      dotDir = config.home.homeDirectory + "/.config/zsh";
      autosuggestion.enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      shellAliases = {
        kill_bg = "kill $(jobs -l | sed -r 's/\[([0-9]+)\].+/%\1/')";
      };

      initContent = ''
      # disable syntax highlighting on paste, to avoid speed issues
      zle_highlight+=(paste:none)

      # Not deterministic, but the Nix option doesn't seem to work.
      export EDITOR=nvim

      # zoxide
      eval "$(zoxide init zsh)"

      ### Fix slowness of pastes with zsh-syntax-highlighting.zsh
      pasteinit() {
        OLD_SELF_INSERT=''${''${(s.:.)widgets[self-insert]}[2,3]}
        zle -N self-insert url-quote-magic
      }

      pastefinish() {
        zle -N self-insert $OLD_SELF_INSERT
      }
      zstyle :bracketed-paste-magic paste-init pasteinit
      zstyle :bracketed-paste-magic paste-finish pastefinish
      ### Fix slowness of pastes

      # functions
      gch () {
        if [[ -z $1 ]]; then
          SEARCH=("fzf")
        else
          SEARCH=("fzf" "--query" "$1")
        fi
        git checkout "$(git branch --all | {$SEARCH[@]} | tr -d ' ')"
      }
      '';
    };

    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
      ];
    };


    #####
    #
    # bash

    programs.bash = {
      enable = true;
      enableCompletion = true;
      bashrcExtra = ''
      set -o vi
      '';
    };


    #####
    #
    # prompt

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
    };


    #####
    #
    # Environments

    home.sessionVariables = {
      EDITOR = "nvim";
    }
    // sessionVariablesForLinux
    // sessionVariablesForDarwin;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };


    #####
    #
    # CLI utilities

    programs.eza = {
      enable = true;
    };

    programs.nnn = {
      enable = true;
      package = pkgs.nnn.override ({ withNerdIcons = true; });
      bookmarks = {
        h = "~";
        d = "~/Development";
      };
    };

    programs.tmux = {
      enable = true;
      terminal = "tmux-256color";
      prefix = "C-a";
      sensibleOnTop = false;
      historyLimit = 100000;
      extraConfig = ''
        set -ga terminal-overrides ",*:Tc"
        set -g base-index 1
        set -g pane-base-index 1
        set -g renumber-windows on
        setw -g mode-keys vi

        set -g mouse on

        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"

        bind -r C-h select-window -t :-
        bind -r C-l select-window -t :+

        bind -r h select-pane -L
        bind -r j select-pane -D
        bind -r k select-pane -U
        bind -r l select-pane -R

        set -g status-interval 1
        set -g status-left-length 30
        set -g status-right-length 50

        set -g allow-rename off
        set -g automatic-rename off
      '';
      plugins = with pkgs; [
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'
            set -g @catppuccin_window_tabs_enabled on
          '';
        }
        tmuxPlugins.resurrect
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-boot 'on'
            set -g @continuum-restore 'on'
          '';
        }
        (tmuxPlugins.tmux-floax.overrideAttrs (old: {
          postPatch = (old.postPatch or "") + ''
            substituteInPlace scripts/utils.sh \
              --replace-fail 'tmux bind -n c-M-b' 'tmux bind -n C-M-b'
          '';
        }))
        tmuxPlugins.yank
      ];
    };

    programs.zellij = {
      enable = true;
      settings = {
        pane_frames = false;
        simplified_ui = true;
        hide_frame_for_single_pane = true;
        theme = "oxocarbon";
        copy_on_select = true;
        scrollback = 10000;
        mouse_mode = true;
        auto_layout = true;
        attach_existing_session = true;
        default_layout = "compact";
        plugins = {
          zjstatus = {
            location = "file:${zjstatus}";
          };
        };
      };
      enableBashIntegration = false;
      enableZshIntegration = false;
      extraConfig = ''
        themes {
          oxocarbon {
            // base00 = #161616, base01 = ~#262626, base02 = ~#393939, base03 = ~#525252
            // base04 = ~#dde1e7, base09 = #78a9ff, base11 = #33b1ff
            // base12 = #ff7eb6, base13 = #42be65, base14 = #be95ff, base15 = #82cfff
            text_unselected {
              base 221 225 231
              background 22 22 22
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            text_selected {
              base 221 225 231
              background 57 57 57
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            ribbon_unselected {
              base 22 22 22
              background 82 82 82
              emphasis_0 255 126 182
              emphasis_1 221 225 231
              emphasis_2 120 169 255
              emphasis_3 190 149 255
            }
            ribbon_selected {
              base 22 22 22
              background 120 169 255
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 190 149 255
              emphasis_3 66 190 101
            }
            table_title {
              base 66 190 101
              background 0
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            table_cell_unselected {
              base 221 225 231
              background 22 22 22
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            table_cell_selected {
              base 221 225 231
              background 57 57 57
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            list_unselected {
              base 221 225 231
              background 22 22 22
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            list_selected {
              base 221 225 231
              background 57 57 57
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 66 190 101
              emphasis_3 190 149 255
            }
            // frame_unselected: base = divider line color (~base01), bg = terminal bg
            // Using base01 (~#262626) as the line color gives a subtle separator
            frame_unselected {
              base 38 38 38
              background 22 22 22
              emphasis_0 82 82 82
              emphasis_1 57 57 57
              emphasis_2 57 57 57
              emphasis_3 57 57 57
            }
            frame_selected {
              base 120 169 255
              background 0
              emphasis_0 255 126 182
              emphasis_1 130 207 255
              emphasis_2 190 149 255
              emphasis_3 0
            }
            frame_highlight {
              base 255 126 182
              background 0
              emphasis_0 190 149 255
              emphasis_1 255 126 182
              emphasis_2 255 126 182
              emphasis_3 255 126 182
            }
            exit_code_success {
              base 66 190 101
              background 0
              emphasis_0 51 177 255
              emphasis_1 22 22 22
              emphasis_2 190 149 255
              emphasis_3 120 169 255
            }
            exit_code_error {
              base 255 126 182
              background 0
              emphasis_0 130 207 255
              emphasis_1 0
              emphasis_2 0
              emphasis_3 0
            }
          }
        }
      '';
      layouts = {
        compact = ''
          layout {
              default_tab_template {
                  children
                  pane size=1 borderless=true {
                      plugin location="file:${zjstatus}" {
                          format_left   "{mode} #[fg=#78a9ff,bold]{session}"
                          format_center "{tabs}"
                          format_right  "{command_git_branch} {datetime}"
                          format_space  ""

                          hide_frame_for_single_pane "true"

                          mode_normal  "#[bg=#78a9ff] "
                          mode_tmux    "#[bg=#ff7eb6] "

                          tab_normal   "#[fg=#525252] {name} "
                          tab_active   "#[fg=#dde1e7,bold,italic] {name} "

                          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                          command_git_branch_format      "#[fg=#78a9ff] {stdout} "
                          command_git_branch_interval    "10"
                          command_git_branch_rendermode  "static"

                          datetime        "#[fg=#525252,bold] {format} "
                          datetime_format "%A, %d %b %Y %H:%M"
                          datetime_timezone "Europe/Berlin"
                      }
                  }
              }

              // Floating layout: small centered pane (~60% width, ~70% height)
              swap_floating_layout name="centered" {
                  floating_panes {
                      pane { x "20%"; y "15%"; width "60%"; height "70%"; }
                  }
              }

              // Floating layout: near-fullscreen (~90% width, ~90% height)
              swap_floating_layout name="fullscreen" {
                  floating_panes {
                      pane { x "5%"; y "5%"; width "90%"; height "90%"; }
                  }
              }
          }
        '';
      };
    };

    #####
    #
    # Version control

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "brhutchins";
          email = data.email.personal;
          signingkey = config.home.homeDirectory + "/.ssh/id_ed25519.pub";
        };
        init.defaultBranch = "main";
        core = {
          editor = "nvim";
        };
        # Sign all commits using ssh key
        commit.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = config.home.homeDirectory + "/.config/git/allowed_signers";
      };
    };

    programs.diff-so-fancy = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.gh = {
      enable = true;
      settings.gitProtocol = "ssh";
    };

    home.file.".config/git/allowed_signers".text =
      "${data.email.personal} ${builtins.readFile (config.home.homeDirectory + "/.ssh/id_ed25519.pub")}";


    #####
    #
    # Editors
    local.editors = {
      nvim.enable = true;
      helix.enable = true;
    };

    local.editors.doom.enable = true;


    #####
    #
    # Fonts

    fonts.fontconfig.enable = mkIf cfg.gui.enable true;


    #####
    #
    # GUI

    programs.firefox = mkIf (cfg.gui.enable && isLinux) {
      enable = true;
    };

    local.terminals.kitty.enable = mkIf cfg.gui.enable true;
    local.terminals.wezterm.enable = mkIf cfg.gui.enable true;


    #####
    #
    # Darwin
    local.darwin.core.enable = stdenv.isDarwin;

  };
}


