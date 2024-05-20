return {

	{ -- LuaLine {{{
		"hoob3rt/lualine.nvim", -- Vim mode line
		lazy = false,
		config = function()
			local lsp_progress = function()
				local filtered_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
				if #filtered_clients > 0 then
					-- local names = ""
					-- for _, v in ipairs(filtered_clients) do
					--   names = names .. " " .. v.name
					-- end
					-- return " LSP:" .. names
					return " " .. #filtered_clients .. ""
				else
					return ""
				end
			end
			local colors = require("colors").colors

			local custom_gruvbox = nil
			if require("colors").theme == "gruvbox" then
				custom_gruvbox = require("lualine.themes.gruvbox")

				-- Change the background of lualine_c section for normal mode
				custom_gruvbox.normal.c = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.visual.c = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.replace.c = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.insert.c = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.command.c = { bg = colors.bg1, fg = colors.fg }

				custom_gruvbox.normal.x = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.visual.x = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.replace.x = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.insert.x = { bg = colors.bg1, fg = colors.fg }
				custom_gruvbox.command.x = { bg = colors.bg1, fg = colors.fg }
			end
			require("lualine").setup({
				extensions = {
					"toggleterm",
					"lazy",
        },
				options = {
					theme = custom_gruvbox or "auto",
					section_separators = "",
					component_separators = "",
					globalstatus = true,
				},
				sections = {
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
							color = function(_)
								return { fg = vim.bo.modified and colors.yellow or nil }
							end,
							shorting_target = 50,
							symbols = {
								-- modified = '󰆓',      -- Text to show when the file is modified.
								-- readonly = '',      -- Text to show when the file is non-modifiable or readonly.
								-- unnamed = '[*]', -- Text to show for unnamed buffers.
								-- newfile = '󰈔',     -- Text to show for newly created file before first write

								modified = "", -- Text to show when the file is modified.
								readonly = "", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[*]", -- Text to show for unnamed buffers.
								newfile = "", -- Text to show for newly created file before first write
							},
						},
						"location",
						{
							"diff",
							-- symbols = { added = ' ', modified = '󰝤 ', removed = ' ' },
							symbols = { added = " ", modified = " ", removed = " " },
						},
						{
							"diagnostics",
							-- symbols = { error = " ", warn = " ", hint = " ", info = "󰋼 " }
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_x = {
						{
							lsp_progress,
							on_click = function()
								vim.cmd("LspInfo")
							end,
							color = { fg = colors.blue },
						},
						{
							"encoding",
							fmt = string.upper,
							color = { fg = colors.green },
						},
						{
							"fileformat",
							fmt = string.upper,
							icons_enabled = false,
							color = { fg = colors.green },
						},
						{
							--        function ()
							--          return string.upper(vim.bo.filetype)
							--        end,
							-- -- color = { fg = colors.blue },
							-- color = { fg = colors.orange },
							"filetype",
							-- fmt = string.upper,
							-- color = { fg = colors.orange }
						},
						{
							"branch",
							icon = "",
							color = { fg = colors.purple },
							---@param str string
							fmt = function(str)
								if str:len() > 50 then
									str = str:sub(0, 47) .. "..."
								end
								return str
							end,
							on_click = function()
								require("neogit").open()
							end,
						},
					},
					lualine_y = {},
					lualine_z = {
						-- {
						--   '" "',
						--   padding = 0
						-- }
					},
				},
			})
			vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
			vim.api.nvim_create_autocmd("LspAttach", {
				group = "lualine_augroup",
				callback = require("lualine").refresh,
			})
			vim.api.nvim_create_autocmd("LspDetach", {
				group = "lualine_augroup",
				callback = require("lualine").refresh,
			})
		end,
		dependencies = {
			"nvim-web-devicons",
		},
		cond = NOT_VSCODE,
	}, -- }}}
	-- {
	--   "vigoux/notifier.nvim",
	--   event = "VeryLazy",
	--   config = function()
	--     require'notifier'.setup {}
	--   end,
	--   cond = NOT_VSCODE
	--
	-- },
	{
		"j-hui/fidget.nvim",
		event = "VeryLazy",
		opts = {
			notification = {
				override_vim_notify = true, -- Automatically override vim.notify() with Fidget
			},
		},
	},
	-- {
	--   'kevinhwang91/nvim-bqf',
	--   config = function()
	--     require("bqf").setup({
	--       preview = {
	--         winblend = 0,
	--         border = require("hover").border
	--       }
	--     })
	--   end,
	--   ft = 'qf',
	--   cond = NOT_VSCODE
	-- },
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		config = function()
			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

			require("ibl").setup({
				enabled = true,
				exclude = {
					filetypes = {
						"help",
						"terminal",
						"lazy",
						"lspinfo",
						"TelescopePrompt",
						"TelescopeResults",
						"mason",
						"alpha",
						"",
					},
					buftypes = {
						"terminal",
					},
				},

				scope = {
					enabled = false,
					show_start = false,
					show_end = false,
					-- char = "│",
					highlight = { "IblScopeChar", "IblScopeChar", "IblScopeFunction" },
				},
			})
		end,
		event = "VeryLazy",
		cond = NOT_VSCODE,
	},
  {
    'yorickpeterse/nvim-pqf',
    event = 'VeryLazy',
    opts = {
      signs = {
        error = { text = ' ', hl = 'DiagnosticSignError' },
        warning = { text = ' ', hl = 'DiagnosticSignWarn' },
        info = { text = ' ', hl = 'DiagnosticSignInfo' },
        hint = { text = ' ', hl = 'DiagnosticSignHint' },
      },
      -- By default, only the first line of a multi line message will be shown. When this is true, multiple lines will be shown for an entry, separated by a space
      show_multiple_lines = false,
      -- How long filenames in the quickfix are allowed to be. 0 means no limit. Filenames above this limit will be truncated from the beginning with `filename_truncate_prefix`.
      max_filename_length = 0,
      -- Prefix to use for truncated filenames.
      filename_truncate_prefix = '[...]',
    }

  }
  -- {
  --   "levouh/tint.nvim",
  --   event = "VeryLazy",
  --   config = function()
  --     require("tint").setup({
  --       tint = -20,  -- Darken colors, use a positive value to brighten
  --       saturation = 0.8,  -- Darken colors, use a positive value to brighten
  --     })
  --   end
  -- }
  -- {
  --   'rcarriga/nvim-notify',
  --   init = function()
  --     vim.notify = require("notify")
  --   end
  -- }
  -- {'stevearc/qf_helper.nvim', cond = NOT_VSCODE}, -- Quickfix helper :QF{command}
}
