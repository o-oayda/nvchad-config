local npairs = require("nvim-autopairs")
local Rule = require("nvim-autopairs.rule")
local utils = require("luasnip-latex-snippets.util.utils")

-- npairs.setup({
--   -- …your existing opts…
-- })

-- stop auto-pairing "(" in math zones so LuaSnip handles it
npairs.add_rules({
  Rule("(", ")", "tex")
    :with_pair(function()
      return not utils.is_math(false)  -- false => use vimtex detection; true if you enabled treesitter
    end),
})
