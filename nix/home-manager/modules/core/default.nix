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
    // sessionVariablesForLinux;

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
        tmuxPlugins.tmux-floax
      ];
    };

    programs.zellij = {
      enable = true;
      settings = {
        borderless = true;
        pane_frames = false;
        simplified_ui = true;
        hide_frame_for_single_pane = true;
        theme = "catppuccin_mocha";
        copy_on_select = true;
        scrollback = 10000;
        mouse_mode = true;
        auto_layout = true;
        attach_existing_session = true;
        default_layout = "compact";
        plugins = {
          zjstatus = {
            location = "https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm";
          };
        };
      };
      enableBashIntegration = false;
      enableZshIntegration = false;
      # extraConfig = ''
      #   themes {
      #     catppuccin_mocha {
      #       bg 1e1e2e
      #       fg cdd6f4
      #       red f38ba8
      #       green a6e3a1
      #       yellow f9e2af
      #       blue 89b4fa
      #       magenta f5c2e7
      #       cyan 94e2d5
      #       orange fab387
      #       black 45475a
      #       white f5e0dc
      #     }
      #   }
      # '';
      layouts = {
        compact = ''
          layout {
              default_tab_template {
                  children
                  pane size=1 borderless=true {
                      plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                          format_left   "{mode} #[fg=#89B4FA,bold]{session}"
                          format_center "{tabs}"
                          format_right  "{command_git_branch} {datetime}"
                          format_space  ""

                          hide_frame_for_single_pane "true"

                          mode_normal  "#[bg=blue] "
                          mode_tmux    "#[bg=#ffc387] "

                          tab_normal   "#[fg=#6C7086] {name} "
                          tab_active   "#[fg=#9399B2,bold,italic] {name} "

                          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                          command_git_branch_format      "#[fg=blue] {stdout} "
                          command_git_branch_interval    "10"
                          command_git_branch_rendermode  "static"

                          datetime        "#[fg=#6C7086,bold] {format} "
                          datetime_format "%A, %d %b %Y %H:%M"
                          datetime_timezone "Europe/Berlin"
                      }
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


