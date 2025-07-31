require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- find functions and methods in file
vim.keymap.set('n', '<leader>sf', function()
  require('telescope.builtin').lsp_document_symbols({
    symbols = { 'function', 'method', 'class' }
  })
end, { desc = 'Search functions/methods in current file' })

vim.keymap.set('n', '<leader>rk', function()
  dofile(vim.fn.stdpath("config") .. "/lua/mappings.lua")
end, { desc = 'Reload keymaps' })

-- vibe coding
vim.keymap.set({ "n", "v" }, "<C-a>", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

-- git
map(
  "n",
  "<leader>gh",
  "<cmd>Gitsigns preview_hunk_inline<cr>",
  {noremap = true, silent = true}
)

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
