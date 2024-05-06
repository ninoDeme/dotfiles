-- lsp setup functions {{{

local function keymappings(client, bufnr)
	local opts = { noremap = true, silent = true }

	-- lsp Key mappings
	vim.keymap.set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, opts)
	vim.keymap.set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, opts)
	vim.keymap.set("n", "[e", function()
		vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end, opts)
	vim.keymap.set("n", "]e", function()
		vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	end, opts)

	-- Whichkey
	local keymap_l = {
		l = {
			name = "Code",
			r = {
				function()
					vim.lsp.buf.rename()
				end,
				"Rename",
			},
			a = {
				function()
					require("actions-preview").code_actions()
				end,
				"Code Actions",
			},
			-- a = { function() vim.lsp.buf.code_action() end, "Code Action" },
			i = { "<cmd>LspInfo<CR>", "Lsp Info" },
			f = {
				function()
					vim.lsp.buf.format()
				end,
				"Format Document",
			},
			e = {
				function()
					require("telescope.builtin").diagnostics({ severity = vim.diagnostic.severity.ERROR })
				end,
				"Errors",
			},
			d = {
				function()
					require("telescope.builtin").diagnostics()
				end,
				"Diagnostics",
			},
		},
	}

	local keymap_g = {
		name = "Goto",
		s = {
			function()
				vim.lsp.buf.signature_help()
			end,
			"Signature Help",
		},
		-- d = { function() vim.lsp.buf.definition() end, "View Definition" },
		-- D = { function() vim.lsp.buf.references() end, "View References" },
		-- I = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
		-- h = { function() vim.lsp.buf.type_definition() end, "View Type Signature" }
		d = {
			function()
				require("telescope.builtin").lsp_definitions({ show_line = false })
			end,
			"View Definition",
		},
		D = {
			function()
				require("telescope.builtin").lsp_references({ show_line = false, include_declaration = false })
			end,
			"View References",
		},
		I = {
			function()
				require("telescope.builtin").lsp_implementations()
			end,
			"Goto Implementation",
		},
		h = {
			function()
				require("telescope.builtin").lsp_type_definitions()
			end,
			"View Type Signature",
		},
	}
	local whichkey = require("which-key")
	whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>", mode = { "n", "v" } })
	whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
	whichkey.register({ K = {
		function()
			vim.lsp.buf.hover()
		end,
		"View Hover",
	} }, { buffer = bufnr })
end

local lsp_opts = {
	on_attach = function(client, bufnr)
		-- Use LSP as the handler for formatexpr.
		-- See `:help formatexpr` for more information. 'gq'
		vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

		-- Configure key mappings
		keymappings(client, bufnr)
	end,

	capabilities = require("cmp_nvim_lsp").default_capabilities(),
  }
-- }}}

return {
	{
		"neovim/nvim-lspconfig",
    cond = NOT_VSCODE,
		event = "VeryLazy",
    init = function()
			local border = require("hover").border
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
        silent = true,
			})
			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				border = border,
				focusable = false,
				relative = "cursor",
				silent = true,
			})

			-- local signs = { Error = "", Warn = "", Hint = "", Info = "󰋼" }
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end
		end,
		config = function()
			local lspconfig = require("lspconfig")

			-- Borders for LspInfo winodw
			local win = require("lspconfig.ui.windows")
			local _default_opts = win.default_opts

			local border = require("hover").border

			win.default_opts = function(options)
				local opts = _default_opts(options)
				opts.border = border
				return opts
			end

			-- Lua Language Server Config {{{
			lspconfig.lua_ls.setup({
				settings = {
					Lua = {
						runtime = {
							-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
							version = "LuaJIT",
						},
						diagnostics = {
							-- Get the language server to recognize the `vim` global
							globals = { "vim" },
						},
						workspace = {
							-- Make the server aware of Neovim runtime files
							-- library = vim.api.nvim_get_runtime_file("", true),
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
								[vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
							},
							checkThirdParty = false,
						},
						-- Do not send telemetry data containing a randomized but unique identifier
						telemetry = {
							enable = false,
						},
					},
				},
				on_attach = lsp_opts.on_attach,
				capabilities = lsp_opts.capabilities,
			}) -- }}}

			lspconfig.angularls.setup(vim.tbl_extend("force", lsp_opts, {
				filetypes = { "typescript", "html", "typescriptreact", "typescript.tsx", "angular.html" },
			}))
			lspconfig.html.setup(vim.tbl_extend("force", lsp_opts, {
				filetypes = { "html", "templ", "angular.html" },
			}))
			lspconfig.cssls.setup(lsp_opts)
			lspconfig.tailwindcss.setup(vim.tbl_extend("force", lsp_opts, {
				filetypes = {
					"aspnetcorerazor",
					"astro",
					"astro-markdown",
					"blade",
					"clojure",
					"django-html",
					"htmldjango",
					"edge",
					"eelixir",
					"elixir",
					"ejs",
					"erb",
					"eruby",
					"gohtml",
					"gohtmltmpl",
					"haml",
					"handlebars",
					"hbs",
					"html",
					"html-eex",
					"heex",
					"jade",
					"leaf",
					"liquid",
					"markdown",
					"mdx",
					"mustache",
					"njk",
					"nunjucks",
					"php",
					"razor",
					"slim",
					"twig",
					"css",
					"less",
					"postcss",
					"sass",
					"scss",
					"stylus",
					"sugarss",
					"javascript",
					"javascriptreact",
					"reason",
					"rescript",
					"typescript",
					"typescriptreact",
					"vue",
					"svelte",
					"templ",
					"angular.html",
					"heex",
				},
			}))
			-- lspconfig.rust_analyzer.setup(lsp_opts)
			lspconfig.pyright.setup(lsp_opts)
			lspconfig.tsserver.setup(vim.tbl_extend("force", lsp_opts, {
				init_options = {
          hostInfo = "neovim",
					plugins = {
						{
							name = "@vue/typescript-plugin",
							location = vim.fn.expand("$NVM_BIN") .. "../lib/node_modules/@vue/typescript-plugin",
							languages = { "javascript", "typescript", "vue" },
						},
					},
				},
				filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue" }
      }))
			lspconfig.volar.setup(lsp_opts)
			lspconfig.emmet_language_server.setup(vim.tbl_extend("force", lsp_opts, {
				filetypes = {
					"css",
					"eruby",
					"html",
					"htmldjango",
					"javascriptreact",
					"less",
					"pug",
					"sass",
					"scss",
					"typescriptreact",
					"angular.html",
				},
			}))

			lspconfig.dartls.setup(lsp_opts)
			lspconfig.clangd.setup(lsp_opts)
			lspconfig.svelte.setup(lsp_opts)
			lspconfig.elixirls.setup(vim.tbl_extend("force", lsp_opts, {
				cmd = { vim.fn.expand("~/.local/share/elixir-ls/release/language_server.sh") },
			}))
		end,
	},

	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init({
				preset = "codicons",
			})
		end,
		cond = NOT_VSCODE,
	},
	{
		"aznhe21/actions-preview.nvim",
		config = function()
			require("actions-preview").setup({
				telescope = { make_value = nil, make_make_display = nil, layout_strategy = "bottom_pane" },
			})
		end,
		dependencies = { "nvim-telescope/telescope.nvim" },
		keys = {
			{ "<leader>la", desc = "Code Actions", mode = { "v", "n" } },
		},
		cond = NOT_VSCODE,
	},

	{
		"williamboman/mason-lspconfig.nvim",
		cond = NOT_VSCODE,
		lazy = true,
		event = "VeryLazy",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason-lspconfig").setup({
				automatic_installation = true,
			})
		end,
	},

	{
		"mfussenegger/nvim-jdtls",
		cond = NOT_VSCODE,
		event = "VeryLazy",
		dependencies = {
			"mason.nvim",
			"nvim-dap",
		},
		config = function()
			local function setup_server()
				local java_opts = vim.tbl_extend("force", lsp_opts, {
					cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
					root_dir = vim.fs.dirname(
						vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]
					),
					init_options = {
						bundles = {
							vim.fn.glob(
								vim.fn.stdpath("data")
									.. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
								true
							),
						},
					},
				})
				require("jdtls").start_or_attach(java_opts)
			end

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "java",
				callback = function()
					local mason_reg = require("mason-registry")
					if not mason_reg.is_installed("jdtls") then
						if vim.fn.confirm("Download Language Server (jdtls)?", "&Yes\n&No", 1) == 1 then
							local pkg = mason_reg.get_package("jdtls")

							vim.notify("Installing jdtls", nil, { title = "Mason Install" })
							pkg:install()

							pkg:on(
								"install:success",
								vim.schedule_wrap(function()
									vim.notify("[mason.nvim] jdtls was successfully installed")
									setup_server()
								end)
							)
							pkg:on(
								"install:failed",
								vim.schedule_wrap(function()
									vim.notify(
										"[mason.nvim] failed to install jdtls. Installation logs are available in :Mason and :MasonLog",
										vim.log.levels.ERROR
									)
								end)
							)
						end
					else
						setup_server()
					end
				end,
			})
		end,
	},
	-- {
	--   'mrded/nvim-lsp-notify',
	--   config = function()
	--     require('lsp-notify').setup({})
	--   end,
	--   event = "VeryLazy"
	-- }
}

-- vim: ts=2 sts=2 sw=2 et
