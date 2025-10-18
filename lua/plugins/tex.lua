return {
  {
    "lervag/vimtex",
    ft = { "tex", "plaintex", "latex" },  -- load only for these filetypes
    init = function()                     -- globals MUST be set before the plugin loads
      vim.g.vimtex_view_method = "skim"
      -- vim.g.vimtex_view_method = "sioyek"
      vim.g.vimtex_quickfix_mode = 0
      vim.g.vimtex_syntax_enabled = 1
      vim.g.vimtex_fold_enabled = 1

      -- quality-of-life
      vim.o.foldlevelstart = -1
      vim.o.foldenable = true              -- ensure folding is on
      vim.o.foldcolumn = "1"               -- see a gutter for folds (optional)

      vim.g.vimtex_fold_types = {
        sections = { enabled = 1 },
        envs     = { enabled = 1 },
        preamble = { enabled = 1 },
        items    = { enabled = 0 },  -- turn off if you hate itemize folds
        markers  = { enabled = 0 },
      }
    end,
    config = function()
      -- usually nothing needed here; init was the important part
    end,
  },
  {
    "o-oayda/luasnip-latex-snippets.nvim",
    lazy = false, -- don't lazy load https://github.com/iurimateus/luasnip-latex-snippets.nvim/discussions/18
    -- vimtex isn't required if using treesitter
    dependencies = { "L3MON4D3/LuaSnip", "lervag/vimtex" },
    config = function()
      require'luasnip-latex-snippets'.setup()
      -- or setup({ use_treesitter = true })
      require("luasnip").config.setup { enable_autosnippets = true }
    end,
  }
}
