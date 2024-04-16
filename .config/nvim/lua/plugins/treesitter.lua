return {
	{
		"nvim-treesitter/nvim-treesitter",
		cond = NOT_VSCODE,
		lazy = true,
		event = "VeryLazy",
		config = function()
			require("nvim-treesitter.configs").setup({
				highlight = {
					enable = true,
				},
				rainbow = {
					enable = false,
				},
				indent = {
					enable = true,
					disable = { "dart" },
				},
				autotag = {
					enable = NOT_VSCODE(),
					enable_rename = true,
					enable_close = true,
					enable_close_on_slash = false,
					filetypes = {
						"html",
						"javascript",
						"typescript",
						"javascriptreact",
						"typescriptreact",
						"svelte",
						"vue",
						"tsx",
						"jsx",
						"rescript",
						"xml",
						"php",
						"markdown",
						"astro",
						"glimmer",
						"handlebars",
						"hbs",
						"angular.html",
						"heex",
					},
				},

				ensure_installed = {
					"typescript",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"json",
					"jsdoc",
					"javascript",
					"sql",
					"vim",
					"vimdoc",
					"html",
					"css",
					"scss",
					"angular",
					"dap_repl",
				},
			})

			require("treesitter-context").setup({ enable = true, throttle = true })

			-- if vim.uv.os_uname().sysname == "Windows_NT" then
			--    require('nvim-treesitter.install').compilers = { "clang" }
			-- end
			--
			-- require 'nvim-treesitter.install'.prefer_git = false
		end,
		dependencies = {
			"romgrk/nvim-treesitter-context",
			"p00f/nvim-ts-rainbow",
			"windwp/nvim-ts-autotag",
			{
        "LiadOz/nvim-dap-repl-highlights",
        opts = {},
      },
		},
	}, -- Parsesr and highlighter for a lot of languages
	{
		"romgrk/nvim-treesitter-context", -- Shows the context (current function or method)
		dependencies = "nvim-treesitter",
		cond = NOT_VSCODE,
	},
	{
		"JoosepAlviste/nvim-ts-context-commentstring",
		dependencies = "nvim-treesitter",
		config = function()
			require("ts_context_commentstring").setup({
				enable_autocmd = false,
			})
		end,
	},
	{
		"p00f/nvim-ts-rainbow",
		-- opts = {},
		cond = NOT_VSCODE,
	},
	{
		"windwp/nvim-ts-autotag",
		opts = {},
		cond = NOT_VSCODE,
	},
}
