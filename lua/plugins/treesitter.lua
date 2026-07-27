return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  lazy = false,
  dependencies = {
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  config = function()
    vim.treesitter.language.register("javascript", "ojs")

    local ensure_installed = {
      "python",
      "snakemake",
      "lua",
      "bash",
      "javascript",
      "markdown",
      "markdown_inline",
    }

    if vim.fn.executable("tree-sitter") == 1 then
      local generate_help = vim.fn.system({ "tree-sitter", "generate", "--help" })
      if not generate_help:find("%-%-no%-bindings") then
        require("nvim-treesitter.install").ts_generate_args = {
          "generate",
          "--abi",
          tostring(vim.treesitter.language_version),
        }
      end
      table.insert(ensure_installed, "latex")
    end

    require('nvim-treesitter.configs').setup {
      ensure_installed = ensure_installed,
      highlight = {
        enable = true,
        disable = function(lang, bufnr)
          local ft = vim.bo[bufnr].filetype
          return lang == "latex" and vim.tbl_contains({ "tex", "plaintex", "latex" }, ft)
        end,
      },
      indent = { enable = true, disable = { "latex" } },

      textobjects = {
        select = {
          enable = true,
          lookahead = true, -- jumps to next textobj automatically
          keymaps = {
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
          },
        },
      },
    }
    end,
  }
