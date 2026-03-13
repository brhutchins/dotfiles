{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.local.editors.nvim;

  nvim-oh-lucy-theme = with pkgs; vimUtils.buildVimPlugin {
    pname = "oh-lucy.nvim";
    version = "2023-01-07";
    src = fetchFromGitHub {
      owner = "Yazeed1s";
      repo = "oh-lucy.nvim";
      rev = "706c74fe8dcc2014dc17bbc861a05d27623e06e3";
      sha256 = "sha256-DY40tabglFYGXB2NwCpTM5QHUt+uoO8Ti6XBfN3ocAU=";
    };
  };
in
{
  options.local.editors.nvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };

    dotfilesPath = mkOption {
      type = types.path;
      default = (import ../../data).dotfilesPath;
    };
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;

      viAlias = true;
      vimAlias = true;

      globals = {
        mapleader = " ";
        maplocalleader = "  ";
        choosewin_overlay_enable = 1;
        oceanic_next_terminal_bold = 1;
        oceanic_next_terminal_italic = 1;
      };

      colorschemes.oxocarbon = {
        enable = true;
      };

      opts = {
        # General options
        expandtab = true;
        tabstop = 2;
        shiftwidth = 2;
        ignorecase = true;
        smartcase = true;
        number = true;
        splitright = true;
        termguicolors = true;
        list = true;
        hidden = true;
        cursorline = true;
        completeopt = [ "menuone" "noselect" ];

        # Whitespace (from whitespace.lua)
        listchars = {
          trail = "·";
          extends = "»";
          precedes = "«";
          nbsp = "⣿";
          tab = "<->";
        };

        # Font
        guifont = "Hasklug Nerd Font:h12,Hasklig:h10";
      };

      keymaps = [
        # General (from keybindings.lua)
        { mode = "n"; key = "<leader><space>"; action = ":set hlsearch!<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>w"; action = "<C-w>"; options.silent = true; }
        { mode = "n"; key = "<leader><tab>c"; action = ":tabclose<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader><tab>n"; action = ":tabnew<CR>"; options.silent = true; }

        # Telescope
        { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>."; action = "<cmd>Telescope file_browser path=%:p:h<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>,"; action = "<cmd>Telescope buffers<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>/"; action = "<cmd>Telescope git_files<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>lr"; action = "<cmd>Telescope lsp_references<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>ls"; action = "<cmd>Telescope lsp_workspace_symbols<CR>"; options.silent = true; }

        # Trouble
        { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>xw"; action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>xd"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>xl"; action = "<cmd>Trouble loclist toggle<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>xq"; action = "<cmd>Trouble qflist toggle<CR>"; options.silent = true; }
        { mode = "n"; key = "gR"; action = "<cmd>Trouble lsp_references toggle<CR>"; options.silent = true; }

        # Git
        { mode = "n"; key = "<leader>gg"; action = "<cmd>Neogit<CR>"; options.silent = true; }

        # CodeCompanion
        { mode = "n"; key = "<leader>cc"; action = "<cmd>CodeCompanionChat Toggle<CR>"; options.silent = true; }
        { mode = "v"; key = "<leader>cc"; action = "<cmd>CodeCompanionChat Toggle<CR>"; options.silent = true; }
        { mode = "n"; key = "<leader>cp"; action = "<cmd>CodeCompanionActions<CR>"; options.silent = true; }
        { mode = "v"; key = "<leader>cp"; action = "<cmd>CodeCompanionActions<CR>"; options.silent = true; }

        # Choose window
        { mode = "n"; key = "<leader>wp"; action = "<Plug>(choosewin)"; }
      ];

      autoCmd = [
        # Terminal (from terminal/init.lua)
        {
          event = [ "TermOpen" ];
          pattern = [ "*" ];
          command = "setlocal foldcolumn=1 nonumber";
        }
        # Highlight on yank (from options.lua)
        {
          event = [ "TextYankPost" ];
          pattern = [ "*" ];
          callback = {
             __raw = "function() vim.highlight.on_yank({on_visual = false}) end";
          };
        }
        # CodeCompanion (sensible chat window)
        # {
        #   event = [ "FileType" ];
        #   pattern = [ "codecompanion" ];
        #   command = "setlocal nonumber norelativenumber signcolumn=no nolist | let b:gitgutter_enabled = 0";
        # }
      ];

      plugins = {
        # web-devicons.enable = true;
        mini-icons = {
          enable = true;
          mockDevIcons = true;
        };

        lsp = {
          enable = true;
          servers = {
            hls = {
              enable = true;
              installGhc = false;
            };
            rust_analyzer = {
              enable = true;
              installCargo = false;
              installRustc = false;
            };
            pyright.enable = true;
            lua_ls.enable = true;
            nixd.enable = true;
            gopls.enable = true;
          };
          onAttach = ''
            vim.api.nvim_create_autocmd("CursorMoved", {
              command = "lua vim.lsp.buf.clear_references()",
              pattern = "<buffer>",
            })
          '';
          keymaps.lspBuf = {
            gD = "declaration";
            gd = "definition";
            K = "hover";
            gi = "implementation";
            "<C-k>" = "signature_help";
            "<space>wa" = "add_workspace_folder";
            "<space>wr" = "remove_workspace_folder";
            "<space>wl" = "list_workspace_folders";
            "<space>D" = "type_definition";
            "<space>rn" = "rename";
            "<space>ca" = "code_action";
            gr = "references";
            "<space>f" = "format";
          };
          keymaps.diagnostic = {
            "<space>e" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
            "<space>q" = "setloclist";
          };
        };

        blink-cmp = {
          enable = true;
          settings = {
            sources = {
              default = [ "lsp" "path" "buffer" "copilot" ];
              providers.copilot = {
                name = "copilot";
                module = "blink-copilot";
                score_offset = 100;
                async = true;
              };
              per_filetype = {
                codecompanion = [ "codecompanion" ];
              };
            };
            completion = {
              list.selection = { auto_insert = true; preselect = false; };
              menu = {
                border = "single";
                draw.columns.__raw = ''
                  {
                    { "label", "label_description", gap = 1 },
                    { "kind_icon", "kind" },
                    { "source_name" },
                  }
                '';
              };
              documentation.window.border = "single";
              ghost_text = { enabled = true; show_without_selection = true; show_with_selection = true; };
            };
            keymap = {
              preset = "enter";
              "<Tab>" = [ "select_next" "fallback" ];
              "<S-Tab>" = [ "select_prev" "fallback" ];
            };
            signature = { enabled = true; window.border = "single"; };
          };
        };

        treesitter = {
          enable = true;
          nixGrammars = true;
          settings = {
            highlight.enable = true;
            indent.enable = true;
          };
        };

        ts-autotag.enable = true;

        telescope = {
          enable = true;
          extensions.file-browser.enable = true;
          settings.pickers.buffers.theme = "dropdown";
        };

        trouble.enable = true;

        neogit = {
          enable = true;
          settings = {
            integrations.diffview = true;
            use_magit_keybindings = true;
          };
        };

        diffview = {
          enable = true;
        };

        comment.enable = true;

        copilot-lua = {
          enable = true;
          settings.suggestion.enabled = false;
        };

        nvim-autopairs.enable = true;

        mini = {
          enable = true;
          modules.indentscope = {
            symbol = "│";
          };
        };

        lualine = {
          enable = true;
          settings.options = {
            theme = "auto";
            component_separators = "";
            section_separators = "";
          };
        };

        nvim-lightbulb.enable = true;

        gitgutter.enable = true;

        # surround module uses vim-surround or mini-surround
        vim-surround.enable = true;

        snacks = {
          enable = true;
          settings = {
            terminal.enable = true;
            input.enable = true;
            picker.enable = true;
          };
        };

        codecompanion = {
          enable = true;
          settings = {
            strategies = {
              chat.adapter = "opencode";
              inline.adapter = "opencode";
              agent.adapter = "opencode";
            };
            display.chat.window.opts = {
              number = false;
              relativenumber = false;
              signcolumn = "no";
            };
          };
        };

        render-markdown = {
          enable = true;
          settings = {
            file_types = [ "markdown" "codecompanion" ];
          };
        };

        octo = {
          enable = true;
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        blink-copilot
        agda-vim
        diffview-nvim
        haskell-vim
        lean-nvim
        luasnip
        plenary-nvim
        popup-nvim
        rose-pine
        vim-choosewin
        vim-lion
        vim-nix
        vim-python-pep8-indent
        vim-sneak
        vim-vsnip
        vim-vsnip-integ

        # Custom plugins
        nvim-oh-lucy-theme
      ];

      extraConfigLua = ''
        require("rose-pine").setup({
          variant = "main",
          palette = {
            main = {
              base = "#16181d",
              surface = "#1f222a",
              overlay = "#2a2f3a",
            },
          },
        })
        vim.cmd("colorscheme rose-pine")

        -- Custom autopairs rules
        local npairs = require('nvim-autopairs')
        local Rule   = require('nvim-autopairs.rule')

        npairs.add_rules {
          Rule(' ', ' ')
            :with_pair(function (opts)
              local pair = opts.line:sub(opts.col - 1, opts.col)
              return vim.tbl_contains({ '()', '[]', '{}' }, pair)
            end),
          Rule('( ', ' )')
              :with_pair(function() return false end)
              :with_move(function(opts)
                  return opts.prev_char:match('.%)') ~= nil
              end)
              :use_key(')'),
          Rule('{ ', ' }')
              :with_pair(function() return false end)
              :with_move(function(opts)
                  return opts.prev_char:match('.%}') ~= nil
              end)
              :use_key('}'),
          Rule('[ ', ' ]')
              :with_pair(function() return false end)
              :with_move(function(opts)
                  return opts.prev_char:match('.%]') ~= nil
              end)
              :use_key(']')
        }

        -- Set colorscheme manually
        -- vim.cmd("colorscheme catppuccin")

        -- Lightbulb update
        vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

        -- Lean setup
        require('lean').setup{
          abbreviations = { builtin = true },
          mappings = true,
        }
      '';
    };
  };
}
