return {
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      local dap_python = require("dap-python")
      local util = require("lspconfig.util")

      local util = require("lspconfig.util")

      local function get_project_root()
        local filepath = vim.fn.expand("%:p")
        if filepath == "" or filepath == nil then
          -- No file loaded, fallback to cwd
          local cwd = vim.fn.getcwd()
          return cwd
        end

        local root = util.root_pattern(".git")(filepath)
        if root then
          return root
        else
          local cwd = vim.fn.getcwd()
          return cwd
        end
      end
      
      local function get_python_path()
        local cwd = get_project_root()
        if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
          return cwd .. "/.venv/bin/python"
        elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
          return cwd .. "/venv/bin/python"
        else
          return "python3"
        end
      end

      local py_path = get_python_path()
      dap_python.setup(py_path)

      dap.configurations.python = {
        {
         type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = get_project_root(),
          console = "integratedTerminal",
          pythonPath = py_path,
          justMyCode = false
        },
      }

      dapui.setup()
      require("nvim-dap-virtual-text").setup({ commented = true })

      -- Signs
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticSignWarn", linehl = "Visual" })

      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end

      -- Keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, opts)
      vim.keymap.set("n", "<leader>dc", dap.continue, opts)
      vim.keymap.set("n", "<leader>do", dap.step_over, opts)
      vim.keymap.set("n", "<leader>di", dap.step_into, opts)
      vim.keymap.set("n", "<leader>dO", dap.step_out, opts)
      vim.keymap.set("n", "<leader>dq", dap.terminate, opts)
      vim.keymap.set("n", "<leader>du", dapui.toggle, opts)
    end,
  },
}
