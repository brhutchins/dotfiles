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

local npairs = require'nvim-autopairs'
local Rule   = require'nvim-autopairs.rule'

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

-- lualine.nvim
require('lualine').setup{
    options = {
      theme = "OceanicNext",
      component_separators = "",
      section_separators = "",
    }
    --[[ options = {
            theme = "onedark",
            component_separators = "",
            section_separators = "",
            icons_enabled = true,
    },

    sections = {
    } ]]
}

-- dev-icons
require("nvim-web-devicons").setup()

-- nvim-lightbulb
vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]

-- Telescope
require("telescope").setup {
  pickers = {
    find_files = {
    },

    file_browser = {
    },

    git_files = {
    },

    buffers = {
      theme = "dropdown",
    },

    live_grep = {
    },

    lsp_references = {
    },

    lsp_workspace_symbols = {
    },
  }
}


require("telescope").load_extension "file_browser"


-- Trouble
require("trouble").setup()


-- Git
require("neogit").setup{
    integrations = {
        diffview = true,
    },
    use_magit_keybindings = true,
}


-- vim-choosewin
vim.g.choosewin_overlay_enable = 1
