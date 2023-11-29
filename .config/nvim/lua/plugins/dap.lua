return {
  {
    'mfussenegger/nvim-dap',
    config = function()
      local signs = {
        {"DapBreakpoint", ""},
        {"DapBreakpointCondition", ""},
        {"DapLogPoint", ""},
        {"DapStopped", "", "DapStoppedLine"},
        {"DapBreakpointRejected", ""},
      }

      for _, val in ipairs(signs) do
        vim.fn.sign_define(val[1], {text=val[2], texthl=val[1], linehl=val[3], numhl=''})
      end
    end,
    keys = {
      {'<leader>db', function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
      {'<leader>dc', function() require("dap").continue() end, desc = "Continue"},
      {'<leader>di', function() require("dap").step_into() end, desc = "Step Into"},
      {'<leader>do', function() require("dap").step_over() end, desc = "Step Over"},
      {'<leader>dp', function() require("dap").pause() end, desc = "Pause"},
      {'<leader>dq', function() require("dap").disconnect() end, desc = "Disconnect"},
      {'<leader>dR', function() require("dap").restart() end, desc = "Restar"},
      {'<leader>dr', function() require("dap").repl.open() end, desc = "Open REPL"},
      {'<leader>dh', function() require("dap.ui.widgets").hover() end, desc = "Hover Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").preview() end, desc = "Preview Widget"},
      {'<leader>df', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames) end, desc = "Frames Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end, desc = "Scopes Widget"},
    },
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = {},
      }
    },
    cond = NOT_VSCODE
  },
  -- {
  --   "jay-babu/mason-nvim-dap.nvim",
  --   dependencies = {
  --     "mason.nvim"
  --   }
  -- },
}
