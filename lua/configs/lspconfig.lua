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

lspconfig.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    texlab = {
      -- Robust: find nearest Makefile up the tree, cd there, run `make all`
      build = {
        executable = "bash",
        args = {
          "-lc",
          -- 1-liner: walk up to a dir containing Makefile, then run `make all`
          'dir="$(dirname "%f")"; while [ "$dir" != "/" ] && [ ! -f "$dir/Makefile" ]; do dir="$(dirname "$dir")"; done; [ -f "$dir/Makefile" ] || { echo "Makefile not found"; exit 1; }; cd "$dir" && make all',
        },
        onSave = false,             -- build on save (or set false if you prefer :TexlabBuild)
        forwardSearchAfter = true, -- jump to the PDF after a successful build
      },
      -- Forward search (change viewer if not on Linux/zathura)
      forwardSearch = {
        executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
        args = { "-r", "-g", "%l", "%p", "%f" }, -- add "-g" to avoid focus steal
      }
      -- If you ever move outputs to a folder (e.g. out/), uncomment:
      -- auxDirectory = "out",
      -- logDirectory = "out",
      -- pdfDirectory = "out",
    },
  },
}
-- lspconfig.texlab.setup {
--   settings = {
--     texlab = {
--       auxDirectory = ".",
--       bibtexFormatter = "texlab",
--       build = {
--         executable = "latexmk",
--         args = { "-pdf", "-interaction=nonstopmode", "-synctex=1", "%f" },
--         onSave = false,               -- auto build on save
--         forwardSearchAfter = true,   -- jump to PDF after build
--       },
--       forwardSearch = {
--         executable = "/Applications/Skim.app/Contents/SharedSupport/displayline",
--         args = { "%l", "%p", "%f" },
--       },
--       chktex = { onOpenAndSave = true, onEdit = false },
--       latexFormatter = "latexindent",
--       latexindent = { modifyLineBreaks = false },
--     },
--   },
-- }

-- Enable your LSP servers
local servers = { "html", "cssls", "pyright" }
vim.lsp.enable(servers)
