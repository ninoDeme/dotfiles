return {
	{
		"nvim-telescope/telescope.nvim", -- Fuzzy finder over lists
		lazy = true,
		cmd = "Telescope",
		config = function() -- Shamelessly stolen from github.com/NvChad/NvChad
			local telescope = require("telescope")
			local telescope_actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions
			telescope.setup({
				defaults = {
					prompt_prefix = "   ",
					selection_caret = "  ",
					entry_prefix = "  ",
					initial_mode = "insert",
					selection_strategy = "reset",
					-- sorting_strategy = "ascending",
					-- layout_strategy = "horizontal",
					-- layout_config = {
					-- 	horizontal = {
					-- 		prompt_position = "top",
					-- 		preview_width = 0.55,
					-- 		results_width = 0.8,
					-- 	},
					-- 	vertical = {
					-- 		mirror = false,
					-- 	},
					bottom_pane = {
						theme = "ivy",
					},
					-- 	cursor = {
					-- 		width = 150,
					-- 		height = 15,
					-- 	},
					-- 	width = 0.87,
					-- 	height = 0.80,
					-- 	preview_cutoff = 120,
					-- },
					file_ignore_patterns = { "node_modules" },
					path_display = { "truncate" },
					-- border = {},
					-- borderchars = { " ", " ", " ", " ", " ", " ", " ", " " },
					color_devicons = true,
					set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
					mappings = {
						n = {
							["q"] = telescope_actions.close,
							["<C-Down>"] = telescope_actions.cycle_history_next,
							["<C-Up>"] = telescope_actions.cycle_history_prev,
							["<C-k>"] = telescope_actions.move_selection_previous,
							["<C-j>"] = telescope_actions.move_selection_next,
							["<C-l>"] = telescope_actions.select_default,
							["l"] = telescope_actions.select_default,
						},
						i = {
							["<C-k>"] = telescope_actions.move_selection_previous,
							["<C-j>"] = telescope_actions.move_selection_next,
							["<C-Down>"] = telescope_actions.cycle_history_next,
							["<C-Up>"] = telescope_actions.cycle_history_prev,
							["<C-l>"] = telescope_actions.select_default,
						},
					},
				},
				pickers = {
					buffers = {
						mappings = {
							n = {
								["<C-x>"] = telescope_actions.delete_buffer,
							},
							i = {
								["x"] = telescope_actions.delete_buffer,
								["<C-x>"] = telescope_actions.delete_buffer,
							},
						},
					},
					find_files = {
						hidden = true,
					},
					live_grep = {
						additional_args = { "-." },
					},
				},
				extensions = {
					file_browser = {
						hidden = true,
						hijack_netrw = false,
						no_ignore = true,
						respect_gitignore = false,
						dir_icon = "",
						grouped = true,
						prompt_path = true,
						mappings = {
							n = {
								["h"] = fb_actions.goto_parent_dir,
								["<C-h>"] = fb_actions.goto_parent_dir,
								["."] = fb_actions.toggle_hidden,
							},
							i = {
								["<C-h>"] = fb_actions.goto_parent_dir,
								["<C-.>"] = fb_actions.toggle_hidden,
							},
						},
					},
				},
			})

			require("telescope").load_extension("file_browser")

      vim.keymap.set({'n'}, '<leader>st', "<cmd>Telescope themes<cr>", { desc = 'Themes' })
		end,
		dependencies = "nvim-lua/plenary.nvim",
		cond = NOT_VSCODE,
		keys = {
			{ "<leader>ss", "<cmd>Telescope live_grep<cr>", desc = "Grep" },
			{ "<leader>sb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Highlights" },
			{ "<leader>sr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
			{
				"<leader>sd",
				function()
					require("telescope.builtin").diagnostics({ severity_limit = vim.diagnostic.severity.HINT })
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sD",
				function()
					require("telescope.builtin").diagnostics({ severity_limit = vim.diagnostic.severity.ERROR })
				end,
				desc = "Errors",
			},
			{ "<leader>,", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{
				"<leader>gb",
				function()
					require("telescope.builtin").git_branches()
				end,
				desc = "Branches",
			},
		},
	},
	{
		"natecraddock/telescope-zf-native.nvim",
		config = function()
			require("telescope").load_extension("zf-native")
		end,
		after = { "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
			{ "<leader><leader>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
		},
		lazy = true,
		dependencies = "nvim-telescope/telescope.nvim",
		cond = NOT_VSCODE,
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		lazy = true,
		event = "VeryLazy",
		cond = NOT_VSCODE,
		keys = {
			{
				"<leader>.",
				"<cmd>Telescope file_browser path=%:p:h select_buffer=true<CR>",
				desc = "File Browser (current dir)",
			},
			{ "<leader>e", "<cmd>Telescope file_browser<CR>", desc = "File Browser (root)" },
		},
	},
}
