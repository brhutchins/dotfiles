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
    git
    bitwarden

    # Language servers
    rnix-lsp

    # nix-specific
    nix-prefetch-scripts

    # GUI
    kitty
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
    initExtra = ''
    # Set prompt
    autoload -U promptinit && promptinit && prompt pure
    '';
  };

  programs.git = {
    enable = true;
    userName = "brhutchins";
    userEmail = "bhutchins@gmail.com";
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
          name = "kommentary";
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
  home.file.".config/nvim/lua".source = ./nvim/lua;

  home.sessionVariables = { EDITOR = "nvim"; };

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
