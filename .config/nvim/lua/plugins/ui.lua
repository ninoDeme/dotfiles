return {

	{
		"hoob3rt/lualine.nvim",
		lazy = false,
		-- enabled = false,
		config = function()
			local lsp_progress = function()
				local filtered_clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
				if #filtered_clients > 0 then
					return " " .. #filtered_clients
				else
					return ""
				end
			end

			require("lualine").setup({
				extensions = {
					"toggleterm",
					"lazy",
					"quickfix",
					"overseer",
				},
				options = {
					-- theme = custom_gruvbox or "auto",
					theme = "auto",
					section_separators = "",
					component_separators = "",
					globalstatus = false,
				},
				sections = {
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
							color = function(_)
								return vim.bo.modified and "lualine_file_modified" or nil
							end,
							shorting_target = 50,
							symbols = {
								modified = "", -- Text to show when the file is modified.
								readonly = "", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "", -- Text to show for newly created file before first write
							},
						},
						"location",
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_x = {
						{
							lsp_progress,
							on_click = function()
								vim.cmd("LspInfo")
							end,
							color = "lualine_lsp",
						},
						{
							"encoding",
							fmt = string.upper,
							color = "lualine_encoding",
						},
						{
							"fileformat",
							fmt = string.upper,
							-- icons_enabled = false,
							symbols = {
								unix = "LF",
								dos = "CRLF",
								mac = "CR",
							},
							color = "lualine_line_ending",
						},
						{
							"filetype",
						},
						-- {
						--   "branch",
						--   icon = "",
						--   color = "lualine_branch",
						--   ---@param str string
						--   fmt = function(str)
						--     if str:len() > 50 then
						--       str = str:sub(0, 47) .. "..."
						--     end
						--     return str
						--   end,
						-- },
					},
					lualine_y = {},
					lualine_z = {
						{
							-- '"▉"',
							'"▊"',
							padding = 0,
						},
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {
						{
							"filename",
							path = 1,
							shorting_target = 50,
							symbols = {
								modified = "", -- Text to show when the file is modified.
								readonly = "", -- Text to show when the file is non-modifiable or readonly.
								unnamed = "[No Name]", -- Text to show for unnamed buffers.
								newfile = "", -- Text to show for newly created file before first write
							},
						},
						"location",
						{
							"diff",
							symbols = { added = " ", modified = " ", removed = " " },
						},
						{
							"diagnostics",
							symbols = { error = " ", warn = " ", hint = " ", info = " " },
						},
					},
					lualine_x = {
						{
							"encoding",
							fmt = string.upper,
							-- color = "lualine_encoding",
						},
						{
							"fileformat",
							fmt = string.upper,
							-- icons_enabled = false,
							symbols = {
								unix = "LF",
								dos = "CRLF",
								mac = "CR",
							},
							-- color = "lualine_line_ending",
						},
						{
							"filetype",
							colored = false,
						},
						-- {
						--   "branch",
						--   icon = "",
						--   color = "lualine_branch",
						--   ---@param str string
						--   fmt = function(str)
						--     if str:len() > 50 then
						--       str = str:sub(0, 47) .. "..."
						--     end
						--     return str
						--   end,
						-- },
					},
					lualine_y = {},
					lualine_z = {},
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

			require("colors").setup()
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
		enabled = false,
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
		event = "VeryLazy",
		config = function()
			-- local hooks = require("ibl.hooks")
			-- hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)

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

				indent = {
					char = "│",
					-- char = "▎",
					highlight = "IblChar",
				},

				scope = {
					char = "│",
					-- char = "▎",
					highlight = "IblScopeChar",
				},
			})
		end,
		cond = NOT_VSCODE,
	},
	{
		"yorickpeterse/nvim-pqf",
		event = "VeryLazy",
		opts = {
			signs = {
				error = { text = " ", hl = "DiagnosticSignError" },
				warning = { text = " ", hl = "DiagnosticSignWarn" },
				info = { text = " ", hl = "DiagnosticSignInfo" },
				hint = { text = " ", hl = "DiagnosticSignHint" },
			},
			-- By default, only the first line of a multi line message will be shown. When this is true, multiple lines will be shown for an entry, separated by a space
			show_multiple_lines = false,
			-- How long filenames in the quickfix are allowed to be. 0 means no limit. Filenames above this limit will be truncated from the beginning with `filename_truncate_prefix`.
			max_filename_length = 0,
			-- Prefix to use for truncated filenames.
			filename_truncate_prefix = "[...]",
		},
	},
	-- {
	--   'rcarriga/nvim-notify',
	--   init = function()
	--     vim.notify = require("notify")
	--   end
	-- }
	-- {'stevearc/qf_helper.nvim', cond = NOT_VSCODE}, -- Quickfix helper :QF{command}
	-- {
	--   "NvChad/ui",
	--   config = function ()
	--     require("nvchad")
	--   end,
	--   lazy = false
	-- }
	{
		"rebelot/heirline.nvim",
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
    enabled = false,
		event = "UiEnter",
		config = function()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local ModeIndicator = {
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,
				static = {
					mode_names = {
						n = "N",
						no = "N?",
						nov = "N?",
						noV = "N?",
						["no\22"] = "N?",
						niI = "Ni",
						niR = "Nr",
						niV = "Nv",
						nt = "Nt",
						v = "V",
						vs = "Vs",
						V = "V_",
						Vs = "Vs",
						["\22"] = "^V",
						["\22s"] = "^V",
						s = "S",
						S = "S_",
						["\19"] = "^S",
						i = "I",
						ic = "Ic",
						ix = "Ix",
						R = "R",
						Rc = "Rc",
						Rx = "Rx",
						Rv = "Rv",
						Rvc = "Rv",
						Rvx = "Rv",
						c = "C",
						cv = "Ex",
						r = "...",
						rm = "M",
						["r?"] = "?",
						["!"] = "!",
						t = "T",
					},
					mode_colors = {
						n = "blue",
						i = "green",
						v = "cyan",
						V = "cyan",
						["\22"] = "cyan",
						c = "orange",
						s = "purple",
						S = "purple",
						["\19"] = "purple",
						R = "orange",
						r = "orange",
						["!"] = "red",
						t = "red",
					},
				},
				provider = function(self)
					return "%5(" .. self.mode_names[self.mode] .. "%)"
				end,
				hl = function(self)
					local mode = self.mode:sub(1, 1) -- get only the first mode character
					return { bg = self.mode_colors[mode], bold = true, fg = utils.get_highlight("StatusLine").fg }
				end,
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}
			local BufferName = {
				provider = function(self)
					local buf = self.bo
					local bufname = self.filename
					if buf.filetype == "fugitive" then
						return "fugitive: " .. vim.fn.fnamemodify(bufname, ":h:h:t")
					elseif buf.filetype == "harpoon" then
						return "Harpoon"
					elseif buf.filetype == "TelescopePrompt" then
						return "Telescope"
					elseif buf.filetype == "TelescopeResults" then
						return "Telescope"
					elseif buf.filetype == "lazy" then
						return "lazy"
					elseif buf.buftype == "help" then
						return "help:" .. vim.fn.fnamemodify(bufname, ":t:r")
					elseif buf.buftype == "terminal" then
						local match = string.match(vim.split(bufname, " ")[1], "term:.*:(%a+)")
						return match ~= nil and match or vim.fn.fnamemodify(vim.env.SHELL, ":t")
					elseif bufname == "" then
						return "[No Name]"
					else
						if not conditions.width_percent_below(#bufname, 0.25) then
							bufname = vim.fn.pathshorten(bufname)
						end
						return bufname
					end
				end,
				hl = function(self)
					if self.bo.modified then
						return { fg = "yellow" }
					end
				end,
			}
			local BufferFlags = {
				{
					condition = function()
						return vim.bo.modified
					end,
					provider = "",
					hl = { fg = "yellow" },
				},
				{
					condition = function()
						return not vim.bo.modifiable or vim.bo.readonly
					end,
					provider = "",
					-- hl = { fg = "orange" },
				},
			}
			local Ruler = {
        -- %l = current line number
        -- %L = number of lines in the buffer
        -- %c = column number
        -- %P = percentage through file of displayed window
        provider = "%7(%l:%2c)"
      }
			local Diff = {}
			local Diagnostics = {}
			local Spacer = {}
			local Lsp = {}
			local BufferEncoding = {}
			local BufferEndings = {}
			local FileType = {}
			local Ender = {}
			local StatusLine = {
				ModeIndicator,
        {
          BufferName,
          BufferFlags,
          { provider = "%<" }
        },
				Ruler,
				Diff,
				Diagnostics,
				Spacer,
				Lsp,
				BufferEncoding,
				BufferEndings,
				FileType,
				Ender,
			}

			require("heirline").setup({
				statusline = StatusLine,
			})
		end,
	},
}
