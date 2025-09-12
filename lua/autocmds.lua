require "nvchad.autocmds"

local spell_dir = vim.fn.stdpath("config") .. "/spell"
vim.fn.mkdir(spell_dir, "p")

-- pick your locales; one file per locale is typical
vim.opt.spellfile = table.concat({
  -- spell_dir .. "/en_au.utf-8.add",
  spell_dir .. "/en.utf-8.add",     -- add more if you like
  -- spell_dir .. "/de.utf-8.add",
}, ",")

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex", "latex" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = "en_au"   -- change if you prefer
  end,
})

-- vim.api.nvim_create_user_command("MakeView", function()
--   vim.cmd("make")
--   if vim.v.shell_error == 0 then
--     vim.schedule(function()
--       if vim.fn.exists(":VimtexView") == 2 then
--         vim.cmd("keepalt VimtexView")
--       end
--     end)
--   else
--     vim.cmd("copen")        -- show errors if build failed
--   end
-- end, {})
