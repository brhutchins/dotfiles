local lspconfig = require("lspconfig")
local capabilities = require('blink.cmp').get_lsp_capabilities()

local on_attach = function(client,bufnr)
  vim.api.nvim_create_autocmd("CursorMoved", {
    command = "lua vim.lsp.buf.clear_references()",
    pattern = "<buffer>",
  })


  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(a,b) vim.api.nvim_set_option_value(a, b, { buf = bufnr }) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

-- Snippets
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true

--
-- LANGUAGES
--

-- Haskell
lspconfig.hls.setup{
  on_attach = on_attach,
  cmd = {  "haskell-language-server", "--lsp" },
  rootPatterns = { "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml" },
  filetypes = { "haskell", "lhaskell" },
  capabilities = capabilities,
}

-- Rust
require'lspconfig'.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      diagnostics = {
        disabled = { "unresolved-import" }
      },
      cargo = {
          loadOutDirsFromCheck = true
      },
      procMacro = {
          enable = true
      },
    },
    capabilities = capabilities,
  }
}


-- Python/Pyright
lspconfig.pyright.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- HTML
lspconfig.html.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "html-languageserver", "--stdio" },
}

-- CSS
require'lspconfig'.cssls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "css-languageserver", "--stdio" },
}

-- Typescript
lspconfig.ts_ls.setup{
  on_attach = on_attach,
  cmd = { "typescript-language-server", "--stdio" },
}

-- Lua
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  settings = {
    Lua = {
        diagnostics = {
          globals = { "vim" },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
  capabilities = capabilities,
}

-- Nix
lspconfig.nil_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
}

-- Purescript
lspconfig.purescriptls.setup {
  on_attach = on_attach,
}

-- Ruby
lspconfig.solargraph.setup{
  on_attach = on_attach,
}

-- Golang
require'lspconfig'.gopls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

-- lean
require('lean').setup{
  abbreviations = { builtin = true },
  lsp = { on_attach = on_attach },
  lsp3 = { on_attach = on_attach },
  mappings = true,
}

-- Java
lspconfig.java_language_server.setup{
  on_attach = on_attach,
  cmd = { "java-language-server" }
}

-- OCaml
require'lspconfig'.ocamllsp.setup{}
