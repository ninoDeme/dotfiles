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
				indent = {
					enable = true,
					disable = { "dart" },
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
		"windwp/nvim-ts-autotag",
    config = function (_)
      require('nvim-ts-autotag').setup({
      opts = {
        enable_rename = true,
        enable_close = true,
        enable_close_on_slash = false,
      },
      aliases = {
        ["angular.html"] = "html",
        ["angular"] = "html",
        ["heex"] = "html",
      }
    })
    end,
    lazy = false,
    cond = NOT_VSCODE,
	},
}
