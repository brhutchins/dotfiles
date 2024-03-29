require("nvim-treesitter.configs").setup {
  ensure_installed = {},
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_cremental = "grm",
    },
  },

  indent = {
    enable = false
  },

  autotag = {
    enable = true,
  }
}
