return {
	-- Autocompletion =======================
	{
		"hrsh7th/nvim-cmp",
		event = "VeryLazy",
		version = false,
		cond = NOT_VSCODE,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
			-- {'saadparwaiz1/cmp_luasnip'}, -- Snippets source for nvim-cmp
			{
				"garymjr/nvim-snippets",
				event = "VeryLazy",
				dependencies = { "rafamadriz/friendly-snippets" },
				opts = {
					friendly_snippets = true,
				},
				keys = {
					{
						"<Tab>",
						function()
							if vim.snippet.active({ direction = 1 }) then
								vim.schedule(function()
									vim.snippet.jump(1)
								end)
								return
							end
							return "<Tab>"
						end,
						expr = true,
						silent = true,
						mode = { "i", "s" },
					},
					{
						"<S-Tab>",
						function()
							if vim.snippet.active({ direction = -1 }) then
								vim.schedule(function()
									vim.snippet.jump(-1)
								end)
								return
							end
							return "<S-Tab>"
						end,
						expr = true,
						silent = true,
						mode = { "i", "s" },
					},
				},
			},
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			-- {'hrsh7th/cmp-cmdline'},
			{ "hrsh7th/cmp-nvim-lsp-signature-help" },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol" },
			{ "ray-x/cmp-treesitter" },
			{ "onsails/lspkind.nvim" },
		},
		config = function()
			local cmp = require("cmp")
			local cmp_map = cmp.mapping.preset.insert({
				["<C-d>"] = cmp.mapping.scroll_docs(5),
				["<C-u>"] = cmp.mapping.scroll_docs(-5),
				["<C-e>"] = cmp.mapping.scroll_docs(1),
				["<C-y>"] = cmp.mapping.scroll_docs(-1),
				["<C-Space>"] = cmp.mapping.complete(),
				["<C-l>"] = cmp.mapping.confirm({ select = true }),
				["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
				["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
			})
			cmp.setup({
				window = {
					completion = {
						border = require("hover").border,
						winhighlight = "Normal:FloatNormal",
					},
					documentation = {
						winhighlight = "Normal:FloatNormal",
						border = require("hover").alt_border,
					},
				},
				snippet = {
					expand = function(args)
						vim.snippet.expand(args.body)
					end,
				},
				mapping = cmp_map,
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "nvim_lsp_signature_help", priority = 0 },
					{ name = "snippets", priority = 1 },
					{ name = "nvim_lsp", priority = 2 },
				}, {
					{ name = "treesitter" },
					{ name = "buffer" },
				}),
				experimental = {
					ghost_text = false,
				},
				formatting = {
					format = require("lspkind").cmp_format({
						mode = "text_symbol",
						maxwidth = 60,
					}),
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline({ '/', '?' }, {
			--   mapping = cmp.mapping.preset.cmdline(),
			--   sources = {
			--     {
			--       { name = 'nvim_lsp_document_symbol' }
			--     },
			--     {
			--       { name = 'buffer' },
			--       { name = 'treesitter'},
			--     }
			--   }
			-- })
			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			-- cmp.setup.cmdline(':', {
			--   mapping = cmp.mapping.preset.cmdline(),
			--   sources = cmp.config.sources(
			--     {
			--       { name = 'path' }
			--     },
			--     {
			--       { name = 'cmdline' }
			--     }
			--   )
			-- })
		end,
	},
}
