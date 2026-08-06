return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "ajbucci/ipynb.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
      -- "nvim-tree/nvim-web-devicons", -- optional, for language icons
      "folke/snacks.nvim", -- optional, for inline images
    },
    opts = {},
    config = function()
      local parser_dir = vim.fn.stdpath("data") .. "/lazy/ipynb.nvim/tree-sitter-ipynb"
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()

      parser_config.ipynb = {
        install_info = {
          url = parser_dir,
          files = { "src/parser.c", "src/scanner.c" },
        },
        filetype = "ipynb",
      }

      require("ipynb").setup()
    end,
    lazy = false,
  },
}
