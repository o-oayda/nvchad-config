return {
  { -- actually functional cmp from https://github.com/NvChad/NvChad/discussions/2608
    "hrsh7th/nvim-cmp",
    opts = function()
      local config = require "nvchad.configs.cmp"
      local cmp = require "cmp"

      config.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }

      config.completion = {
        completeopt = "menu,menuone,noselect",
      }

      config.preselect = cmp.PreselectMode.None

      -- when inside a latex luasnippet, disable the cmp menu so it doesn't
      -- interfere with tab completions
      config.enabled = function()
        local context = require "cmp.config.context"
        if require("luasnip").in_snippet() then
          return false
        end
        -- Optional: disable in comments too
        if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
          return false
        end
        return true
      end

      return config
    end,
  }
}
