return {
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ==== Keymaps ====
      vim.keymap.set("n", "<leader>dr", dap.continue, { desc = "DAP Run/Continue" })
      vim.keymap.set("n", "<leader>dn", dap.step_over, { desc = "DAP Step Over (next)" })
      vim.keymap.set("n", "<leader>ds", dap.step_into, { desc = "DAP Step Into (step)" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dk", function()
        dap.terminate()
      end, { desc = "DAP Kill / Terminate" })

      -- ==== Change colors and signs ====
      vim.fn.sign_define("DapBreakpoint", { text = "🟡", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped", { text = "➡️", texthl = "DapStopped", linehl = "CursorLine", numhl = "" })

      vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = "#FFFF00" })
      vim.api.nvim_set_hl(0, "DapStopped", { fg = "#FFFF00", bold = true })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      handlers = {},
    },
  },
  {
    "mfussenegger/nvim-dap",
  },
}
