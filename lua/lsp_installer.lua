local mason = require("mason")
local mr = require("mason-registry")

mason.setup()

-- List of tools you want guaranteed installed
local ensure_installed = {
  "clangd",         -- C/C++
  "lua-language-server",
  "bash-language-server",
  "pyright",
  "clang-format",
}

-- Install missing ones automatically
for _, name in ipairs(ensure_installed) do
  local p = mr.get_package(name)
  if not p:is_installed() then
    p:install()
  end
end
