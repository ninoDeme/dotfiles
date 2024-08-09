return {
	{
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				lua = { "stylua" },
				javascript = { "prettierd", "prettier" },
				javascriptreact = { "prettierd", "prettier" },
				vue = { "prettierd", "prettier" },
				html = { "prettierd", "prettier" },
				htmlangular = { "prettierd", "prettier" },
				css = { "prettierd", "prettier" },
				scss = { "prettierd", "prettier" },
				typescript = { "prettierd", "prettier" },
				typescriptreact = { "prettierd", "prettier" },
				json = { "prettierd", "prettier" },
				jsonc = { "prettierd", "prettier" },
				ocaml = { "ocamlformat" },
			},
			default_format_opts = {
				lsp_format = "fallback",
				stop_after_first = true,
			},
		},
		keys = {
			{
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format",
			},
		},
	},
}
