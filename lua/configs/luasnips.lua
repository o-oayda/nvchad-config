-- Reload your custom snippets quickly
local snip_opts = {  -- reuse whatever you pass to setup()
  use_treesitter = false,
  allow_on_markdown = false,
}

local reload_luasnip_snippets = function(opts)
  opts = opts or snip_opts

  local ls = require("luasnip")
  ls.cleanup()

  for name in pairs(package.loaded) do
    if name:match("^luasnip%-latex%-snippets") then
      package.loaded[name] = nil
    end
  end

  require("luasnip-latex-snippets").setup(opts)

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) then
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft == "tex" or ft == "markdown" or ft == "quarto" then
        vim.api.nvim_exec_autocmds("FileType", { buffer = buf, modeline = false })
      end
    end
  end

  vim.notify("✅ Luasnip snippets reloaded!")
end

vim.api.nvim_create_user_command("ReloadSnips", function()
  reload_luasnip_snippets()
end, {})

