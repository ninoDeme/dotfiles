return {
	{
		"lambdalisue/vim-manpager",
		cond = NOT_VSCODE,
		cmd = {
			"ASMANPAGER",
			"Man",
		},
		ft = {
			"man",
		},
	}, -- Use vim as a manpager
	{ "nvim-lua/plenary.nvim", cond = NOT_VSCODE }, -- Telescope dependency
	{ "kyazdani42/nvim-web-devicons", cond = NOT_VSCODE }, -- Add icons to plugins
	{ "sedm0784/vim-resize-mode", cond = NOT_VSCODE, keys = { "<C-w>" } },
	{ "editorconfig/editorconfig-vim", event = "VeryLazy" }, -- Editor config support

	-- { 'tpope/vim-surround',             event = 'VeryLazy' }, -- change surrounding of text object (ys<motion> to add surround and cs<motion> to change surrounding
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		config = function()
			require("which-key").register({
				s = { name = "Telescope" },
				t = { name = "+Toggle Numbered Terminals" },
				g = { name = "+Git" },
				d = { name = "+Debug" },
				b = { name = "+Buffers" },
				c = {
					name = "+QuickFix",
					c = {
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
						"Toggle QuickFix",
					},
					n = { "<cmd>:cnext<cr>", "Next Item" },
					b = { "<cmd>:cprevious<cr>", "Previous Item" },
				},
				o = {
					name = "+Open",
					t = { "<Cmd>:terminal<CR>i", "Terminal" },
					["-"] = { "<cmd>Oil<cr>", "Oil" },
				},
				W = { '<Cmd>:call mkdir(expand("%:p:h"),"p")<CR>', "Create dir to current file" },
				["<tab>"] = {
					name = "+Tabs",
					n = { "<Cmd>tabnew<cr>", "New Tab" },
					["<tab>"] = { "gt", "Next Tab" },
					q = { "<cmd>:tabclose<cr>", "Close Tab" },
					t = { "<cmd>:tabnew<cr><cmd>:terminal<cr>", "Tab With Terminal" },
				},
			}, { prefix = "<leader>" })
		end,
		cond = NOT_VSCODE,
	},
	{ "mg979/vim-visual-multi", cond = NOT_VSCODE, event = "VeryLazy" }, -- Multiple cursors (Ctrl+n to select word and Ctrl+Down/Up)
	{ "cohama/lexima.vim", cond = NOT_VSCODE, event = "VeryLazy" },
	{
		"ggandor/leap.nvim",
		dependencies = { "tpope/vim-repeat" },
		config = function()
			require("leap").add_default_mappings()
		end,
		event = "VeryLazy",
	},
	{
		"skywind3000/asyncrun.vim",
		cmd = {
			"AsyncRun",
		},
	},
	-- -- 'vim-scripts/argtextobj.vim' -- add argument text object ia aa
	-- {
	--   'wellle/targets.vim',
	--   event = 'VeryLazy'
	-- },
	--
	-- {
	--   'kana/vim-textobj-entire',
	--   event = 'VeryLazy',
	--   dependencies ={'kana/vim-textobj-user'}
	-- },
	{
		"michaeljsmith/vim-indent-object",
		event = "VeryLazy",
	}, -- add indent text object for motions ii ai
	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewLog",
			"DiffviewRefresh",
			"DiffviewReference",
			"DiffviewFileHistory",
			"DiffviewToggleFiles",
		},
		cond = NOT_VSCODE,
	},

	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		config = function()
			require("mason").setup()
		end,
	},

	{
		"L3MON4D3/LuaSnip",
		cond = NOT_VSCODE,
		event = "VeryLazy",
		build = "make install_jsregexp",
		keys = {
			{
				"<tab>",
				function()
					return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
				end,
				expr = true,
				silent = true,
				mode = "i",
			},
			{
				"<tab>",
				function()
					require("luasnip").jump(1)
				end,
				mode = "s",
			},
			{
				"<s-tab>",
				function()
					require("luasnip").jump(-1)
				end,
				mode = { "i", "s" },
			},
		},
	}, -- Snippets plugin

	-- Color schemes =======================
	{ "ayu-theme/ayu-vim", cond = NOT_VSCODE },
	{
		lazy = false,
		priority = 1006,
		"navarasu/onedark.nvim",
		config = function()
			require("onedark").setup({
				-- toggle_style_key = "<leader>tc", -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
				style = "darker",
			})
			require("onedark").load()

			require("colors")
		end,
		cond = NOT_VSCODE,
	},
	-- {'kana/vim-textobj-user', --- {{{
	--   event = 'VeryLazy',
	--   config = function()
	--     vim.cmd[[
	--     " Regexes
	--     " Note that all regexes are surrounded by (), use that to your advantage.
	--
	--     " Teste usar lookbehind para verificar se não é o nome da tag
	--     " A word: `attr=value`, with no quotes.
	--     let s:RE_WORD = '\(\w\+\)'
	--     " An attribute name: `src`, `data-attr`, `strange_attr`.
	--     let s:RE_ATTR_NAME = '\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)'
	--     " A quoted string.
	--     let s:RE_QUOTED_STR = '\(".\{-}"\)'
	--     " The value of an attribute: a word with no quotes or a quoted string.
	--     let s:RE_ATTR_VALUE = '\(' . s:RE_QUOTED_STR . '\|' . s:RE_WORD . '\)'
	--     " The right-hand side of an XML attr: an optional `=something` or `="str"`.
	--     let s:RE_ATTR_RHS = '\(=' . s:RE_ATTR_VALUE . '\)\='
	--
	--     " The final regex.
	--     let s:RE_ATTR_I = '\(' . s:RE_ATTR_NAME . s:RE_ATTR_RHS . '\)'
	--     let s:RE_ATTR_A = '\s\+' . s:RE_ATTR_I
	--     let s:RE_ATTR_AX = '\s\+' . s:RE_ATTR_NAME
	--
	--     call textobj#user#plugin('angularattr', {
	--     \   'attr-i': {
	--     \     'pattern': s:RE_ATTR_I,
	--     \     'select': 'ix',
	--     \   },
	--     \   'attr-a': {
	--     \     'pattern': s:RE_ATTR_A,
	--     \     'select': 'ax',
	--     \   },
	--     \   'attr-iX': {
	--     \     'pattern': s:RE_ATTR_NAME,
	--     \     'select': 'iX'
	--     \   },
	--     \   'attr-aX': {
	--     \     'pattern': s:RE_ATTR_AX,
	--     \     'select': 'aX'
	--     \   },
	--     \ })
	--
	--     ]]
	--   end
	-- }, --- }}}

	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			if NOT_VSCODE() then
				require("mini.comment").setup({
					options = {
						custom_commentstring = function()
							return require("ts_context_commentstring").calculate_commentstring() or vim.bo.commentstring
						end,
					},
				})

				require("mini.files").setup()

				require("mini.surround").setup({
					mappings = {
						add = "gsa", -- Add surrounding in Normal and Visual modes
						delete = "gsd", -- Delete surrounding
						find = "gsf", -- Find surrounding (to the right)
						find_left = "gsF", -- Find surrounding (to the left)
						highlight = "gsh", -- Highlight surrounding
						replace = "gsr", -- Replace surrounding
						update_n_lines = "gsn", -- Update `n_lines`

						suffix_last = "l", -- Suffix to search with "prev" method
						suffix_next = "n", -- Suffix to search with "next" method
					},
				})

				-- require('mini.cursorword').setup()
				local hipatterns = require("mini.hipatterns")
				hipatterns.setup({
					highlighters = {
						-- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
						fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
						hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
						todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
						note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

						-- Highlight hex color strings (`#rrggbb`) using that color
						hex_color = hipatterns.gen_highlighter.hex_color(),
					},
				})
			end
			require("mini.bracketed").setup()
			require("mini.ai").setup({
				custom_textobjects = {
					g = function()
						local from = { line = 1, col = 1 }
						local to = {
							line = vim.fn.line("$"),
							col = math.max(vim.fn.getline("$"):len(), 1),
						}
						return { from = from, to = to }
					end,
					x = {
						{
							'%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b""()',
							"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b''()",
							"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b{}()",
							"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=[%w_-]+()",
						},
					},
				},
			})
			require("mini.align").setup()
			require("mini.splitjoin").setup()
			require("mini.operators").setup({
				exchange = {
					prefix = "cx",
				},
			})
		end,
		keys = {
			{ mode = "n", "gR", "gr$", remap = true },
			{ mode = "n", "cX", "cx$", remap = true },
			{ "<leader>m", desc = "+Mini" },
			{
				"<leader>me",
				function()
					require("mini.files").open()
				end,
				desc = "Open Mini Files",
			},
			{
				"<leader>m.",
				function()
					require("mini.files").open(vim.fn.expand("%:p:h"))
				end,
				desc = "Open Mini Files at dir",
			},
			{ "gs", desc = "+Surrounding" },
			{ mode = { "n", "v" }, "gsa", desc = "Add surrounding" },
			{ mode = "n", "gsd", desc = "Delete surrounding" },
			{ mode = "n", "gsf", desc = "Find surrounding (to the right)" },
			{ mode = "n", "gsF", desc = "Find surrounding (to the left)" },
			{ mode = "n", "gsh", desc = "Highlight surrounding" },
			{ mode = "n", "gsr", desc = "Replace surrounding" },
			{ mode = "n", "gsn", desc = "Update `n_lines`" },
		},
	},
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

          require("telescope.pickers").new({}, {
              prompt_title = "Harpoon",
              finder = require("telescope.finders").new_table({
                  results = file_paths,
              }),
              previewer = conf.file_previewer({}),
              sorter = conf.generic_sorter({}),
          }):find()
      end

			vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
			vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
			vim.keymap.set("n", "<leader>sh", function() toggle_telescope(harpoon:list()) end)

			vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end)

			vim.keymap.set("n", "<leader>h5", function() harpoon:list():select(5) end)
			vim.keymap.set("n", "<leader>h6", function() harpoon:list():select(6) end)
			vim.keymap.set("n", "<leader>h7", function() harpoon:list():select(7) end)
			vim.keymap.set("n", "<leader>h8", function() harpoon:list():select(8) end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end)
			vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end)
		end,
    keys = {
      {mode = "n", "<leader>h", desc = "+Harpoon"},
      {mode = "n", "<leader>ha", desc = "Add to list"},
      {mode = "n", "<leader>hh", desc = "Toggle List"},
      {mode = "n", "<leader>sh", desc = "Harpoon"},

      {mode = "n", "<leader>h1", desc = "1"},
      {mode = "n", "<leader>h2", desc = "2"},
      {mode = "n", "<leader>h3", desc = "3"},
      {mode = "n", "<leader>h4", desc = "4"},

      {mode = "n", "<leader>h5", desc = "5"},
      {mode = "n", "<leader>h6", desc = "6"},
      {mode = "n", "<leader>h7", desc = "7"},
      {mode = "n", "<leader>h8", desc = "8"},

      -- Toggle previous & next buffers stored within Harpoon list
      {mode = "n", "<C-S-P>", desc = "Harpoon previous"},
      {mode = "n", "<C-S-N>", desc = "Harpoon next"},
    }
	},
}
