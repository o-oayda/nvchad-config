**This repo is supposed to be used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# Notes

- **Texlab commands with `vim.lsp.config`:** Neovim 0.11 deprecates `require("lspconfig").texlab.setup`.  
  This config uses `vim.lsp.config("texlab", …)` instead. Texlab’s built-in configuration registers
  commands such as `:LspTexlabBuild`/`:LspTexlabForward` inside its `on_attach`. To keep those commands
  (so that mappings like `<leader>tb` still work) we:
  1. Deep-copy the default texlab config: `local texlab_defaults = vim.deepcopy(vim.lsp.config["texlab"])`
  2. Wrap texlab’s own `on_attach` and run NvChad’s handler afterwards.
  3. Call `vim.lsp.enable({ ..., "texlab" })` so the server auto-starts for `.tex` buffers.
  This way Texlab still registers its helper commands while our custom Makefile-based build/forward-search
  settings apply.

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
