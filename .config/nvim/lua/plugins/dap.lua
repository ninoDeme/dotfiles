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

      dap.providers.configs["npm_scripts"] = function(bufnr)
        local result = {}
        if vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":t") == "package.json" then
          local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0 ,vim.api.nvim_buf_line_count(bufnr), false)
          local res = require("overseer.json").decode(table.concat(buf_lines, "\n"))
          if res.scripts then
            for script, command in pairs(res.scripts) do
              table.insert(result, {
                type = "node",
                request = "launch",
                name = "npm - " .. script,
                description = command,
                env = {},
                runtimeExecutable = "npm",
                runtimeArgs = { "run", script },
                cwd = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ":h")
              })
            end
          end
        end
        return result
      end

			if not dap.adapters["node"] then
				local node_adapter = {
					type = "server",
					host = "localhost",
					port = "${port}",
					enrich_config = function(config, on_config)
						local final_config = vim.deepcopy(config)
						if final_config.type == "node" then
							final_config.type = "pwa-node"
						end
						on_config(final_config)
					end,
					executable = {
						command = "node",
						args = {
							require("mason-registry").get_package("js-debug-adapter"):get_install_path()
								.. "/js-debug/src/dapDebugServer.js",
							"${port}",
						},
					},
				}
				require("dap").adapters["node"] = node_adapter
				require("dap").adapters["pwa-node"] = node_adapter
			end
			for _, language in ipairs({ "typescript", "javascript", "typescriptreact", "javascriptreact" }) do
				if not dap.configurations[language] then
					dap.configurations[language] = {
						{
							type = "node",
							request = "launch",
							name = "Launch file",
							program = "${file}",
							cwd = "${workspaceFolder}",
						},
						{
							type = "node",
							request = "attach",
							name = "Attach",
							processId = require("dap.utils").pick_process,
							cwd = "${workspaceFolder}",
						},
						{
							type = "node",
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
							type = "node",
							request = "launch",
							name = "Npm start in folder",
							env = {},
							runtimeExecutable = "npm",
							runtimeArgs = { "run", "start" },
							cwd = function()
								local path = vim.fn.input({
									prompt = "Path to executable: ",
									default = vim.fn.getcwd() .. "/",
									completion = "file",
								})
								return path or require("dap").ABORT
							end,
						},
					}
				end
			end
		end,
    -- stylua: ignore
    keys = {
      {'<leader>db', function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint"},
      {'<leader>dl', function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Toggle Log Point"},
      {'<leader>dc', function() require("dap").continue() end, desc = "Continue"},
      {'<leader>di', function() require("dap").step_into() end, desc = "Step Into"},
      {'<leader>do', function() require("dap").step_over() end, desc = "Step Over"},
      {'<leader>du', function() require("dap").step_up() end, desc = "Step Up"},
      {'<leader>dp', function() require("dap").pause() end, desc = "Pause"},
      {'<leader>dq', function() require("dap").disconnect() end, desc = "Disconnect"},
      {'<leader>dx', function() require("dap").close() end, desc = "Kill"},
      {'<leader>dR', function() require("dap").restart() end, desc = "Restart"},
      {'<leader>dr', function() require("dap").repl.toggle() end, desc = "Toggle REPL"},
      {'<leader>dh', function() require("dap.ui.widgets").hover() end, desc = "Hover Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").preview() end, desc = "Preview Widget"},
      {'<leader>df', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").frames) end, desc = "Frames Widget"},
      {'<leader>ds', function() require("dap.ui.widgets").centered_float(require("dap.ui.widgets").scopes) end, desc = "Scopes Widget"},
    },
		dependencies = {
			{
				"overseer.nvim",
			},
		},
	},
}
