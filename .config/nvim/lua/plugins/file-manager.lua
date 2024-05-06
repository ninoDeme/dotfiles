return {
	{
		"stevearc/oil.nvim",
		opts = {
			keymaps = {
				["<C-l>"] = "actions.select",
				["gr"] = "actions.refresh",
				["g:"] = "actions.open_cmdline",
				["g;"] = "actions.open_cmdline_dir",
				["<leader>ot"] = "actions.open_terminal",
			},
      win_options = {
        winbar = ' %f',
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
      },
			columns = {
				{
					"permissions",
				},
				{
					"size",
					highlight = "OilSize",
				},
				{
					"mtime",
					highlight = "OilMtime",
				},
				{
          "icon",
          -- directory = "",
          directory = "",
        },
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
