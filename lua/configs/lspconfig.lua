local lspconfig = require "lspconfig"
local on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

require("nvchad.configs.lspconfig").defaults()

-- Detect OS for forward search
local uname = vim.loop.os_uname().sysname
local forward_search_executable
local forward_search_args

if (uname == "Darwin") or (uname == "Linux") then
  forward_search_executable = "sioyek"
  forward_search_args = { "--forward-search-file", "%f", "--forward-search-line", "%l", "%p" }
else
  forward_search_executable = nil
  forward_search_args = {}
end

-- JavaScript/TypeScript LSP with global type checking for JS
vim.lsp.config("ts_ls", {
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
})

lspconfig.texlab.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    trace = { server = 'verbose' },
    texlab = {
      -- Robust: find nearest Makefile up the tree, cd there, run `make all`
      build = {
        executable = "bash",
        args = {
          "-lc",
          [[
          src="%f";
          dir="$(dirname "$src")";
          probe="$dir"; found="";
          while [ "$probe" != "/" ]; do [ -f "$probe/Makefile" ] && { found="$probe"; break; }; probe="$(dirname "$probe")"; done;
          if [ -n "$found" ]; then
            echo "texlab-build: Makefile at $found"; cd "$found" && make all;
          else
            echo "texlab-build: no Makefile; latexmk fallback"; cd "$dir" && latexmk -pdf -interaction=nonstopmode -synctex=1 -file-line-error "$(basename "$src")";
          fi
          ]]
        },
        onSave = false,             -- build on save (or set false if you prefer :TexlabBuild)
        forwardSearchAfter = true, -- jump to the PDF after a successful build
      },
      -- Forward search (change viewer if not on Linux/zathura)
      forwardSearch = {
        executable = forward_search_executable,
        args = forward_search_args,
      }
      -- If you ever move outputs to a folder (e.g. out/), uncomment:
      -- auxDirectory = "out",
      -- pdfDirectory = "out",
    },
  logDirectory = "out",
  },
}

-- lspconfig.clangd.setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
--   settings = {},
-- }
--
-- Enable your LSP servers
local servers = { "html", "cssls", "pyright", "clangd" }
vim.lsp.enable(servers)
