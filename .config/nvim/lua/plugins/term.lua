return {
	{
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				persist_size = false,
				-- shade_terminals = false,
				winbar = {
					enabled = true,
				},
				-- direction = 'hori'
			})
			local tmuxTerm
			local function toggle_tmux()
				if not tmuxTerm then
					tmuxTerm = require("toggleterm.terminal").Terminal:new({
						cmd = "tmux new-session -A -s '" .. vim.uv.cwd() .. "'\n",
						hidden = false,
						display_name = "Tmux Session",
						id = 1,
					})
				end
				tmuxTerm:toggle()
			end

			local terms = {}
			local function lim(opts)
				opts = opts or {}
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_state = require("telescope.actions.state")

				local scan = require("plenary.scandir")
				local Path = require("plenary.path")
				local folders = scan.scan_dir(vim.uv.cwd(), { hidden = false, only_dirs = true, depth = 1 })
				local Terminal = require("toggleterm.terminal").Terminal
				local picker = pickers.new(opts, {
					prompt_title = "Start",
					layout_strategy = "bottom_pane",
					finder = finders.new_table({
						results = folders,
					}),
					sorter = conf.generic_sorter(opts),
					attach_mappings = function(prompt_bufnr, map)
						actions.select_default:replace(function()
							local picker = action_state.get_current_picker(prompt_bufnr)
							actions.close(prompt_bufnr)

							local selection = picker:get_multi_selection()

							if not selection or #selection == 0 then
								selection = {
									action_state.get_selected_entry(),
								}
							end

							vim.print(vim.inspect(selection))
							for _, v in ipairs(selection) do
								local path = Path.make_relative(Path.new(v[1]), vim.uv.cwd())

								if terms[path] then
								-- terms[path]:send({"", "pnpm start"}, true)
								else
									terms[path] = Terminal:new({
										cmd = "npm start",
										dir = path,
										-- id = (#terms + 1),
										hidden = false,
										display_name = path,
										auto_scroll = true,
										close_on_exit = true,
										on_exit = function()
											terms[path] = nil
										end,
									})
								end
								terms[path]:toggle()
							end
						end)
						return true
					end,
				})
				picker:find()
			end
			vim.keymap.set("n", "<leader>tp", toggle_tmux, { desc = "Toggle Tmux Terminal" })

			vim.keymap.set("n", "<leader>th", lim, { desc = "Run Task/Pick Term" })
		end,
		cond = NOT_VSCODE,
		cmd = {
			"ToggleTerm",
			"ToggleTermToggleAll",
		},
		keys = {
			{ "<leader>1", "<cmd>ToggleTerm 1<CR>", desc = "Toggle Terminal 1" },
			{ "<leader>2", "<cmd>ToggleTerm 2<CR>", desc = "Toggle Terminal 2" },
			{ "<leader>3", "<cmd>ToggleTerm 3<CR>", desc = "Toggle Terminal 3" },
			{ "<leader>4", "<cmd>ToggleTerm 4<CR>", desc = "Toggle Terminal 4" },
			{ "<leader>5", "<cmd>ToggleTerm 5<CR>", desc = "Toggle Terminal 5" },
			{ "<leader>6", "<cmd>ToggleTerm 6<CR>", desc = "Toggle Terminal 6" },
			{ "<leader>7", "<cmd>ToggleTerm 7<CR>", desc = "Toggle Terminal 7" },
			{ "<leader>8", "<cmd>ToggleTerm 8<CR>", desc = "Toggle Terminal 8" },
			{ "<leader>9", "<cmd>ToggleTerm 9<CR>", desc = "Toggle Terminal 9" },
			{ "<leader>st", "<cmd>TermSelect <CR>", desc = "Select Terminal" },
			{ "<leader>tp", desc = "Toggle Tmux Terminal" },
			{ "<leader>th", desc = "Run Task/Pick Term" },
			-- {'<leader>tP', function() require("harpoon.term").gotoTerminal(0) end, desc = 'Open Drawer Terminal in Current Window'},
			{ "<leader>tt", "<cmd>ToggleTerm<CR>", desc = "Toggle Terminal Popup" },
		},
	},
	{
	  'stevearc/overseer.nvim',
	  event = 'VeryLazy',
    dev = true,
	  opts = {
      dap = false
    },

		keys = {
			{ "<leader>rr", "<cmd>OverseerRun<CR>", desc = "Overseer Run" },
			{ "<leader>rR", "<cmd>OverseerRun<CR>", desc = "Overseer Restart Action" },
			{ "<leader>rt", "<cmd>OverseerToggle<CR>", desc = "Overseer Toggle" },
			{ "<leader>ri", "<cmd>OverseerInfo<CR>", desc = "Overseer Info" },
			{ "<leader>ra", "<cmd>OverseerTaskAction<CR>", desc = "Overseer Task Actions" },
    }
	}
}
