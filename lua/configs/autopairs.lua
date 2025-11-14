local M = {}

function M.add_latex_rules()
  local npairs = require("nvim-autopairs")
  local Rule = require("nvim-autopairs.rule")
  local utils = require("luasnip-latex-snippets.util.utils")

  -- disable the generic "(" rule inside TeX so we can control it ourselves
  for _, rule in ipairs(npairs.get_rules("(")) do
    rule.not_filetypes = rule.not_filetypes or {}
    if not vim.tbl_contains(rule.not_filetypes, "tex") then
      table.insert(rule.not_filetypes, "tex")
    end
  end

  -- stop auto-pairing "(" in math zones so LuaSnip handles it
  npairs.add_rules({
    Rule("(", ")", "tex")
      :with_pair(function()
        return not utils.is_math(false) -- false => use vimtex detection; true if you enabled treesitter
      end),
  })
end

return M
