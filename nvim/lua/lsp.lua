local lspconfig = require("lspconfig")

-- Snippets
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- 
-- LANGUAGES
--

-- Haskell
lspconfig.hls.setup{
  cmd = {  "haskell-language-server-wrapper", "--lsp" },
  rootPatterns = { "*.cabal", "stack.yaml", "cabal.project", "package.yaml", "hie.yaml" },
  filetypes = { "haskell", "lhaskell" }
}

-- Rust
require'lspconfig'.rust_analyzer.setup {
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      assist = {
        importMergeBehavior = "last",
        importPrefix = "by_self",
      },
      diagnostics = {
        disabled = { "unresolved-import" }
      },
      cargo = {
          loadOutDirsFromCheck = true
      },
      procMacro = {
          enable = true
      },
      checkOnSave = {
          command = "clippy"
      },
    }
  }
}


-- Python/Pyright
lspconfig.pyright.setup{}

-- HTML
lspconfig.html.setup{
  cmd = { "html-languageserver", "--stdio" },
  filetypes = { "html" },
  init_options = {
    configurationSection = { "html", "css", "javascript" },
    embeddedLanguages = {
      css = true,
      javascript = true
    }
  },
  settings = {}
}

-- Typescript
lspconfig.tsserver.setup{}
