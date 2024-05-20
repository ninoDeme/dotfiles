return {
	{
		"mfussenegger/nvim-dap",
		config = function()
			local signs = {
				{ "DapBreakpoint", "" },
				{ "DapBreakpointCondition", "" },
				{ "DapLogPoint", "" },
				{ "DapStopped", "", "DapStoppedLine" },
				{ "DapBreakpointRejected", "" },
			}

			for _, val in ipairs(signs) do
				vim.fn.sign_define(val[1], { text = val[2], texthl = val[1], linehl = val[3], numhl = "" })
			end

			local dap = require("dap")

			require("dap.ext.vscode").json_decode = require("overseer.json").decode
			require("overseer").patch_dap(true)

			if not dap.adapters["pwa-node"] then
				require("dap").adapters["pwa-node"] = {
					type = "server",
					host = "localhost",
					port = "${port}",
					executable = {
						command = "node",
						-- 💀 Make sure to update this path to point to your installation
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
			end
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
						{
							type = "pwa-node",
							request = "attach",
							name = "attach to port...",
							port = function()
								local port = vim.fn.input({
									prompt = "Port: ",
									default = "9229",
								})
								return port
							end,
						},
						{
							type = "pwa-node",
							request = "launch",
							name = "Launch app.ts in folder in ts-node-dev",
							runtimeExecutable = "node",
							runtimeArgs = { "node_modules/ts-node-dev/lib/bin.js" },
							args = { "--env-file=../.env", "app.ts" },
							cwd = function()
								local path = vim.fn.input({
									prompt = "Path to executable: ",
									default = vim.fn.getcwd() .. "/",
									completion = "file",
								})
								return path
							end,
						},
					}
				end
			end
		end,
    -- stylua: ignore
    keys = {
      {'<leader>db', function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
      {'<leader>dc', function() require("dap").continue() end, desc = "Continue"},
      {'<leader>di', function() require("dap").step_into() end, desc = "Step Into"},
      {'<leader>do', function() require("dap").step_over() end, desc = "Step Over"},
      {'<leader>du', function() require("dap").step_up() end, desc = "Step Up"},
      {'<leader>dp', function() require("dap").pause() end, desc = "Pause"},
      {'<leader>dq', function() require("dap").disconnect() end, desc = "Disconnect"},
      {'<leader>dR', function() require("dap").restart() end, desc = "Restart"},
      {'<leader>dr', function() require("dap").repl.open() end, desc = "Open REPL"},
      {'<leader>dh', function() require("dap.ui.widgets").hover() end, desc = "Hover Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").preview() end, desc = "Preview Widget"},
      {'<leader>df', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames) end, desc = "Frames Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end, desc = "Scopes Widget"},
    },
    dependencies = {
      {
        "stevearc/overseer.nvim",
      },
    },
    cond = NOT_VSCODE,
  },
}
