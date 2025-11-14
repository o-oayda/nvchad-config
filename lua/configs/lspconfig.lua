local nv_on_attach = require("nvchad.configs.lspconfig").on_attach
local capabilities = require("nvchad.configs.lspconfig").capabilities

require("nvchad.configs.lspconfig").defaults()

local texlab_defaults = vim.deepcopy(vim.lsp.config["texlab"] or {})
local texlab_builtin_on_attach = texlab_defaults.on_attach
-- NOTE: texlab ships its own on_attach that registers :LspTexlab* commands.
--       Keep it around and run NvChad's handler afterwards so our keymaps work.

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
  on_attach = nv_on_attach,
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

local texlab_config = vim.tbl_deep_extend("force", {}, texlab_defaults, {
  on_attach = function(client, bufnr)
    if texlab_builtin_on_attach then
      texlab_builtin_on_attach(client, bufnr)
    end
    nv_on_attach(client, bufnr)
  end,
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
        onSave = false,             -- build on save (or set false if you prefer :LspTexlabBuild)
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
})

vim.lsp.config("texlab", texlab_config)

local servers = { "html", "cssls", "pyright", "clangd", "ts_ls", "texlab" }
vim.lsp.enable(servers)
