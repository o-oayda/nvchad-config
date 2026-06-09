local M = {}

local quarto_math_nodes = {
  latex_block = true,
}

local text_nodes = {
  text_mode = true,
  label_definition = true,
  label_reference = true,
}

local code_block_nodes = {
  fenced_code_block = true,
  indented_code_block = true,
}

local function has_parent(node, node_types)
  while node do
    if node_types[node:type()] then
      return true
    end
    node = node:parent()
  end

  return false
end

function M.patch_quarto_math_detection()
  local ts_utils = require("luasnip-latex-snippets.util.ts_utils")
  local original_in_mathzone = ts_utils.in_mathzone
  local original_in_text = ts_utils.in_text

  ts_utils.in_mathzone = function()
    local node = vim.treesitter.get_node({ ignore_injections = false })

    if vim.bo.filetype == "quarto" or vim.bo.filetype == "markdown" then
      if has_parent(node, code_block_nodes) then
        return false
      end

      if has_parent(node, quarto_math_nodes) then
        return true
      end

      if has_parent(node, text_nodes) then
        return false
      end
    end

    return original_in_mathzone()
  end

  ts_utils.in_text = function(check_parent)
    local node = vim.treesitter.get_node({ ignore_injections = false })

    if vim.bo.filetype == "quarto" or vim.bo.filetype == "markdown" then
      if has_parent(node, code_block_nodes) then
        return true
      end

      if has_parent(node, quarto_math_nodes) then
        return false
      end
    end

    return original_in_text(check_parent)
  end
end

M.patch_quarto_math_detection()

-- Reload your custom snippets quickly
local snip_opts = {  -- reuse whatever you pass to setup()
  use_treesitter = false,
  allow_on_markdown = true,
}

local reload_luasnip_snippets = function(opts)
  opts = opts or snip_opts

  local ls = require("luasnip")
  ls.cleanup()
  ls.filetype_extend("quarto", { "markdown" })

  for name in pairs(package.loaded) do
    if name:match("^luasnip%-latex%-snippets") then
      package.loaded[name] = nil
    end
  end

  M.patch_quarto_math_detection()
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

return M
