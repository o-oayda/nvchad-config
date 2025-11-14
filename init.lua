vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

-- for synctex inverse search
-- disable for now
-- local sock = "/tmp/nvimsocket"  -- or ("/tmp/nvim-" .. vim.fn.getpid()) for per-instance
-- if vim.fn.exists("*serverstart") == 1 then
--   pcall(vim.fn.serverstart, sock)
-- end
-- vim.env.NVIM_LISTEN_ADDRESS = sock

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "autocmds"
require "configs.options"
require "lsp_installer"

vim.schedule(function()
  require "mappings"
end)

if vim.loop.os_uname().sysname == "Darwin" then
  vim.o.shell = "/opt/homebrew/bin/fish"
end
