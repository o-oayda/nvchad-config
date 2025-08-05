return {
  "hrsh7th/nvim-cmp",
  -- from https://github.com/hrsh7th/nvim-cmp/discussions/1670
  -- disable pre-selection of first item in hover
  opts = {
    preselect = require("cmp").PreselectMode.None,
    completion = {
      completeopt = 'menu,menuone,noselect',
    }
  },
  -- disable enter key from choosing an option in the hover 
  config = function(_,opts)
    -- opts.mapping["<CR>"] = nil
    require("cmp").setup(opts)
  end,
}
