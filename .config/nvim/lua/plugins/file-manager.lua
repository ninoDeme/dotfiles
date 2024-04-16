return {
	{
		"stevearc/oil.nvim",
		opts = {
			keymaps = {
				["<C-l>"] = "actions.select",
				["gr"] = "actions.refresh",
        ["g:"] = "actions.open_cmdline",
        ["g;"] = "actions.open_cmdline_dir",
        ["<leader>ot"] = "actions.open_terminal"
			},
			columns = {
				"permissions",
				"size",
				"mtime",
				"icon",
			},
			keymaps_help = {
				border = require("hover").alt_border,
        win_opts = {
          winhighlight = "Normal:FloatNormal",
        },
			},
		},
		-- Optional dependencies
		dependencies = { "nvim-tree/nvim-web-devicons" },
		lazy = false,
	},
}
