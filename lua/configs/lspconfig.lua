local lspconfig = require "lspconfig"
local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

require("nvchad.configs.lspconfig").defaults()

-- JavaScript/TypeScript LSP with global type checking for JS
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    javascript = {
      suggest = { completeFunctionCalls = true },
      implicitProjectConfig = {
        checkJs = true,   -- ✅ Type-check JS without per-project config
        target = "ES2020",
        strictNullChecks = true,
        strict = true
      },
    },
    typescript = {
      suggest = { completeFunctionCalls = true },
    },
  },
}

-- Enable your LSP servers
local servers = { "html", "cssls", "pyright" }
vim.lsp.enable(servers)
