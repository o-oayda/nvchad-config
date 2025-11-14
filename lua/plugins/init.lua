return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    opts = require "configs.conform",
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "xiyaowong/transparent.nvim",
    lazy = false,
  --   config = function()
  --     require 'transparent'.clear_prefix("TabLine")
  --     require 'transparent'.clear_prefix("WildMenu") -- possibly not necessary
  --     require('transparent').setup({
  --     groups = {
  --       'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
  --       'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
  --       'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
  --       'SignColumn', 'CursorLine', 'CursorLineNr', 'StatusLine', 'StatusLineNC',
  --       'EndOfBuffer',
  --     },
  --     extra_groups = {
  --       "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
  --       "NvimTreeNormal" -- NvimTree
  --     },
  --   })
  -- end
  },
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)

      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cmp_autopairs = require "nvim-autopairs.completion.cmp"
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end

      require("configs.autopairs").add_latex_rules()
    end,
  }
  -- test new blink
  -- { import = "nvchad.blink.lazyspec" },

  -- {
  -- 	"nvim-treesitter/nvim-treesitter",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"vim", "lua", "vimdoc",
  --      "html", "css"
  -- 		},
  -- 	},
  -- },
}
