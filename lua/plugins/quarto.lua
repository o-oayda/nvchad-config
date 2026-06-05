-- Example in your lazy.nvim plugins file
return {
  "quarto-dev/quarto-nvim",
  ft = { "quarto" }, -- Ensure this is here
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "jmbuhr/otter.nvim",
  },
  config = true, -- Automatically runs the setup function
}
