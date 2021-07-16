-- Compe
require'compe'.setup {
  enabled          = true;
  autocomplete     = true;
  debug            = false;
  min_length       = 1;
  preselect        = "enable";
  throttle_time    = 80;
  source_timeout   = 200;
  resolve_timeout  = 800;
  incomplete_delay = 400;
  max_abbr_width   = 100;
  max_kind_width   = 100;
  max_menu_width   = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
  };
}

-- nvim-autopairs
require("nvim-autopairs").setup()

-- lualine.nvim
require('lualine').setup{
    options = {
            theme = "onedark",
            component_separators = "",
            section_separators = "",
            -- icons_enabled = vim.fn.has("gui_running") and false or true,
              -- For reasons I do not understand, devicons work fine with Hasklig
              -- in terminal (Kitty) nvim, but not in guis. The above would
              -- disable icons in guis, and works perfectly for VimR. Unfortunately,
              -- no other nvim gui reports has("gui_running") accurately. And since
              -- we're using gui colours in the terminal, &t_Co is no help here
              -- either. So, no icons:
            icons_enabled = false,
    },

    sections = {
     -- lualine_x = {'encoding', 'fileformat', 'filetype'},
    }
}

-- dev-icons
require("nvim-web-devicons").setup()

-- Telescope

-- Because of the weird incompatibility between gui devicons and Hasklig,
-- we need to disable devicons in gui clients. Of course, only VimR is
-- going to work properly here, but if I'm in a gui, it's usually VimR.
-- Or, at least, putting up with broken icons in goneovim is the compromise.
local no_gui_devicons = vim.fn.has("gui_running") == 1 and true or false

require("telescope").setup {
  pickers = {
    find_files = {
      disable_devicons = no_gui_devicons,
    },

    file_browser = {
      disable_devicons = no_gui_devicons,
    },

    git_files = {
      disable_devicons = no_gui_devicons,
    },

    buffers = {
      disable_devicons = no_gui_devicons,
      theme = "dropdown",
    },

    live_grep = {
      disable_devicons = no_gui_devicons,
    },
  }
}
