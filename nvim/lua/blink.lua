require("blink.cmp").setup({
  sources = {
    default = { "lsp", "path", "buffer", "copilot" },
    providers = {
      copilot = {
        name = "copilot",
        module = "blink-copilot",
        score_offset = 100,
        async = true,
      },
    },
  },
  completion = {
    list = {
      selection = { auto_insert = true, preselect = false, },
    },
    menu = {
      border = 'single',
      draw = {
        columns = {
          { "label", "label_description", gap = 1 },
          { "kind_icon", "kind" },
          { "source_name" },
        },
      },
    },
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
