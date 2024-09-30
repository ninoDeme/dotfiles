return {
	{ "nvim-lua/plenary.nvim" }, -- Telescope dependency
	{ "nvim-tree/nvim-web-devicons" }, -- Add icons to plugins
	{ "sedm0784/vim-resize-mode", event = "VeryLazy" },

	-- { 'tpope/vim-surround',             event = 'VeryLazy' }, -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").setup({
				preset = "modern",
				delay = function(ctx)
					return 1000
				end,
				spec = {
					{ "<leader><tab>", group = "Tabs" },
					{ "<leader><tab><tab>", "gt", desc = "Next Tab" },
					{ "<leader><tab>c", "<Cmd>tabnew<cr>", desc = "New Tab" },
					{ "<leader><tab>n", "<Cmd>tabnew<cr>", desc = "New Tab" },
					{ "<leader><tab>t", "<cmd>:tabnew<cr><cmd>:terminal<cr>i", desc = "Tab With Terminal" },
					{ "<leader><tab>x", "<cmd>:tabclose<cr>", desc = "Close Tab" },
					{ "<leader>W", '<Cmd>:call mkdir(expand("%:p:h"),"p")<CR>', desc = "Create dir to current file" },
					{ "<leader>b", group = "Buffers" },
					{ "<leader>q", group = "QuickFix" },
					{ "<leader>qb", "<cmd>:cprevious<cr>", desc = "Previous Item" },
					{
						"<leader>qq",
						function()
							local windows = vim.fn.getwininfo()
							for _, win in pairs(windows) do
								if win["quickfix"] == 1 then
									vim.cmd.cclose()
									return
								end
							end
							vim.cmd.copen()
						end,
						desc = "Toggle QuickFix",
					},
					{ "<leader>qn", "<cmd>:cnext<cr>", desc = "Next Item" },
					{ "<leader>d", group = "Debug" },
					{ "<leader>g", group = "Git" },
					{ "<leader>o", group = "Open" },
					{ "<leader>o-", "<cmd>Oil<cr>", desc = "Oil" },
					{ "<leader>ot", "<Cmd>:terminal<CR>i", desc = "Terminal" },
					{ "<leader>s", group = "Telescope" },
					{ "<leader>t", group = "Toggle Numbered Terminals" },
					{
						"[e",
						function()
							vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1, float = true })
						end,
						desc = "Previous Error",
					},
					{
						"]e",
						function()
							vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1, float = true })
						end,
						desc = "Next Error",
					},
				},
			})
		end,
	},
	{ "cohama/lexima.vim", event = "VeryLazy" },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	-- {
	--   "ggandor/leap.nvim",
	--   dependencies = { "tpope/vim-repeat" },
	--   config = function()
	--     require("leap").add_default_mappings()
	--   end,
	--   event = "VeryLazy",
	-- },
	{
		"wellle/targets.vim",
		event = "VeryLazy",
	},
	{
		"kana/vim-textobj-entire",
		event = "VeryLazy",
		dependencies = { "kana/vim-textobj-user" },
	},
	{
		"michaeljsmith/vim-indent-object",
		event = "VeryLazy",
	}, -- add indent text object for motions ii ai
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("mason").setup()
		end,
	},

	-- Color schemes =======================
	-- { "ayu-theme/ayu-vim" },
	{
		enabled = false,
		lazy = false,
		priority = 1006,
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				-- toggle_style_key = "<leader>tc", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				style = "darker",
			})
			require("onedark").load()

			require("colors").setup()
		end,
	},
	{
		enabled = false,
		lazy = false,
		priority = 1006,
		"ellisonleao/gruvbox.nvim",
		config = function()
			require("gruvbox").setup({
				overrides = {
					SignColumn = { link = "Normal" },
				},
			})
			vim.cmd("colorscheme gruvbox")
			require("colors").setup()
		end,
	},
	{
		"kana/vim-textobj-user", --- {{{
		event = "VeryLazy",
		config = function()
			local re_word = [[\(\w\+\)]]
			-- An attribute name: `src`, `data-attr`, `strange_attr`.
			local re_attr_name = [[\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)]]
			-- A quoted string.
			local re_quoted_str = [[\(".\{-}"\)]]
			-- The value of an attribute: a word with no quotes or a quoted string.
			local re_attr_value = [[\(]] .. re_quoted_str .. [[\|]] .. re_word .. [[\)]]
			-- The right-hand side of an XML attr: an optional `=something` or `="str"`.
			local re_attr_rhs = [[\(=]] .. re_attr_value .. [[\)\=]]

			-- The final regex.
			local re_attr_i = [[\(]] .. re_attr_name .. re_attr_rhs .. [[\)]]
			local re_attr_a = [[\s\+]] .. re_attr_i
			local re_attr_ax = [[\s\+]] .. re_attr_name

			vim.fn["textobj#user#plugin"]("angularattr", {
				["attr-i"] = {
					pattern = re_attr_i,
					select = "ix",
				},
				["attr-a"] = {
					pattern = re_attr_a,
					select = "ax",
				},
				["attr-iX"] = {
					pattern = re_attr_name,
					select = "iX",
				},
				["attr-aX"] = {
					pattern = re_attr_ax,
					select = "aX",
				},
			})
		end,
	}, --- }}}
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim", "telescope.nvim" },
		event = "VeryLazy",
		config = function()
			local harpoon = require("harpoon")
			-- Setup harpoon
			harpoon:setup()

			-- Telescope Setup
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
			end

			require("which-key").add({
				{ mode = "n", "<leader>h", group = "+Harpoon" },
				{
					mode = "n",
					"<leader>ha",
					function()
						harpoon:list():add()
					end,
					desc = "Add to List",
				},
				{
					mode = "n",
					"<leader>hh",
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					desc = "Open Harpoon",
				},
				{
					mode = "n",
					"<leader>sh",
					function()
						toggle_telescope(harpoon:list())
					end,
					desc = "Harpoon",
				},
				{
					mode = "n",
					"<leader>1",
					function()
						harpoon:list():select(1)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>2",
					function()
						harpoon:list():select(2)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>3",
					function()
						harpoon:list():select(3)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>4",
					function()
						harpoon:list():select(4)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>5",
					function()
						harpoon:list():select(5)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>6",
					function()
						harpoon:list():select(6)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>7",
					function()
						harpoon:list():select(7)
					end,
					hidden = true,
				},
				{
					mode = "n",
					"<leader>8",
					function()
						harpoon:list():select(8)
					end,
					hidden = true,
				},
			})
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		event = "VeryLazy",
		opts = {
			enable_tailwind = true,
			render = "virtual",
			virtual_symbol_position = "eol",
		},
	},
	{
		"NvChad/base46",
		config = function()
			vim.g.base46_cache = vim.fn.stdpath("cache") .. "/base46"
			require("base46").load_all_highlights()
			require("colors").setup()
			vim.api.nvim_create_autocmd("User", {
				pattern = "NvChadThemeReload",
				callback = require("colors").update_colors,
			})
			local pick = function()
				local pickers = require("telescope.pickers")
				local finders = require("telescope.finders")
				local previewers = require("telescope.previewers")

				local conf = require("telescope.config").values
				local actions = require("telescope.actions")
				local action_set = require("telescope.actions.set")
				local action_state = require("telescope.actions.state")

				local function reload_theme(name)
					require("nvconfig").ui.theme = name
					require("base46").load_all_highlights()
					vim.api.nvim_exec_autocmds("User", { pattern = "NvChadThemeReload" })
				end
				local bufnr = vim.api.nvim_get_current_buf()

				-- show current buffer content in previewer
				local previewer = previewers.new_buffer_previewer({
					define_preview = function(self, entry)
						-- add content
						local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
						vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)

						-- add syntax highlighting in previewer
						local ft = (vim.filetype.match({ buf = bufnr }) or "diff"):match("%w+")
						require("telescope.previewers.utils").highlighter(self.state.bufnr, ft)
					end,
				})

        local default_themes = vim.fn.readdir(vim.fn.stdpath "data" .. "/lazy/base46/lua/base46/themes")
        local custom_themes = vim.uv.fs_stat(vim.fn.stdpath "config" .. "/lua/themes")

        if custom_themes and custom_themes.type == "directory" then
          local themes_tb = vim.fn.readdir(vim.fn.stdpath "config" .. "/lua/themes")
          for _, value in ipairs(themes_tb) do
            table.insert(default_themes, value)
          end
        end

        for index, theme in ipairs(default_themes) do
          default_themes[index] = theme:match "(.+)%..+"
        end

				-- our picker function: colors
				local picker = pickers.new({
					prompt_title = "󱥚 Set Theme",
					previewer = previewer,
					finder = finders.new_table({
						results = default_themes,
					}),
					sorter = conf.generic_sorter(),

					attach_mappings = function(prompt_bufnr)
						-- reload theme while typing
						vim.schedule(function()
							vim.api.nvim_create_autocmd("TextChangedI", {
								buffer = prompt_bufnr,
								callback = function()
									if action_state.get_selected_entry() then
										reload_theme(action_state.get_selected_entry()[1])
									end
								end,
							})
						end)
						-- reload theme on cycling
						actions.move_selection_previous:replace(function()
							action_set.shift_selection(prompt_bufnr, -1)
							reload_theme(action_state.get_selected_entry()[1])
						end)
						actions.move_selection_next:replace(function()
							action_set.shift_selection(prompt_bufnr, 1)
							reload_theme(action_state.get_selected_entry()[1])
						end)

						------------ save theme to chadrc on enter ----------------
						actions.select_default:replace(function()
							if action_state.get_selected_entry() then
								actions.close(prompt_bufnr)
							end
						end)
						return true
					end,
				})

				picker:find()
			end
			vim.keymap.set({ "n" }, "<leader>st", pick, { desc = "Themes" })
		end,
		-- dependencies = {
		-- 	"NvChad/ui",
		-- },
		lazy = false,
		priority = 1006,
	},
	{
		"andrewferrier/debugprint.nvim",
		opts = {},
		keys = {
			{ mode = { "n", "x" }, "g?", desc = "+Debug Print" },
			{ mode = { "n", "x" }, "g?v", desc = "Print variable below" },
			{ mode = { "n", "x" }, "g?V", desc = "Print variable above" },
			{ mode = "n", "g?p", desc = "Print below" },
			{ mode = "n", "g?P", desc = "Print above" },
		},
		cmd = {
			"DeleteDebugPrints",
			"ToggleCommentDebugPrints",
		},
		dependencies = {
			"echasnovski/mini.nvim", -- Needed to enable :ToggleCommentDebugPrints for NeoVim 0.9
		},
	},
}
