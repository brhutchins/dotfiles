require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "buffer" },
  },
  completion = {
    list = {
      selection = { auto_insert = true, preselect = false, },
    },
    menu = { border = 'single' },
    documentation = { window = { border = 'single' } },
    ghost_text = { enabled = true, show_without_selection = true, show_with_selection = true, },
  },
  keymap = {
    preset = "enter",
    ['<Tab>'] = { "select_next", "fallback" },
    ['<S-Tab>'] = { "select_prev", "fallback" },
  },
  signature = { enabled = true, window = { border = 'single' } },
})
