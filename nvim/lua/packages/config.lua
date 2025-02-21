-- cmp
-- local cmp = require'cmp'
-- cmp.setup {
--     snippet = {
--       expand = function(args)
--         vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--       end,
--     },
--     window = {
--       completion = cmp.config.window.bordered(),
--       documentation = cmp.config.window.bordered(),
--     },
--     mapping = cmp.mapping.preset.insert({
--       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--       ['<C-f>'] = cmp.mapping.scroll_docs(4),
--       ['<C-Space>'] = cmp.mapping.complete(),
--       ['<C-e>'] = cmp.mapping.abort(),
--       ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     }),
--     sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       { name = 'vsnip' }, -- For vsnip users.
--       -- { name = 'luasnip' }, -- For luasnip users.
--       -- { name = 'ultisnips' }, -- For ultisnips users.
--       -- { name = 'snippy' }, -- For snippy users.
--     }, {
--       { name = 'buffer' },
--     })
--   }
--
-- comment.nvim
require('Comment').setup()

-- copilot
require("copilot").setup({
  suggestion = {
    enabled = false,
  }
})
require("blink-copilot")

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
