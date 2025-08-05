vim.opt.colorcolumn = "80"

-- LSP function positional argument highlighting
-- removes colour change and underlines current argument
vim.api.nvim_set_hl(0, "LspSignatureActiveParameter", { underline = true })

