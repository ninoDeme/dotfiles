return {
	{
		"rebelot/heirline.nvim",
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
		event = "UiEnter",
		config = function()
			local conditions = require("heirline.conditions")
			local utils = require("heirline.utils")

			local h_colors = require("colors").heirline_colors()

			local ModeIndicator = {
				init = function(self)
					self.mode = vim.fn.mode(1) -- :h mode()
				end,
				static = {
					mode_names = {
						n = "Normal",
						no = "Normal?",
						nov = "Normal?",
						noV = "Normal?",
						["no\22"] = "Normal?",
						niI = "Normal!",
						niR = "Normal!",
						niV = "Normal!",
						nt = "Normal",
						v = "Visual",
						vs = "Visual!",
						V = "V-Line",
						Vs = "V-Line!",
						["\22"] = "V-Block",
						["\22s"] = "V-Block!",
						s = "Select",
						S = "S-Line",
						["\19"] = "S-Block",
						i = "Insert",
						ic = "Insert-C",
						ix = "Insert-X",
						R = "Replace",
						Rc = "Replace-C",
						Rx = "Replace-X",
						Rv = "Virtual Replace",
						Rvc = "Virtual Replace-C",
						Rvx = "Virtual Replace-X",
						c = "Command",
						cv = "Ex",
						r = "...",
						rm = "More",
						["r?"] = "Confirm",
						["!"] = "!Shell",
						t = "Terminal",
					},
					mode_names_mini = { -- change the strings if you like it vvvvverbose!
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
				},
				hl = function(self)
					local color = self.mode_color(self)
					return {
						bg = color,
						bold = true,
						fg = conditions.is_active() and utils.get_highlight("HeirLine").bg,
					}
				end,
				-- update = {
				-- 	"ModeChanged",
				-- 	pattern = "*:*",
				-- 	callback = vim.schedule_wrap(function()
				-- 		vim.cmd("redrawstatus")
				-- 	end),
				-- },
				flexible = 3,
				{
					provider = function(self)
						return " " .. self.mode_names[self.mode]:upper() .. " "
					end,
				},
				{
					provider = function(self)
						return " " .. self.mode_names_mini[self.mode]:upper() .. " "
					end,
				},
			}
			local FileName = {
        init = function(self)
          local buf = vim.bo
          local bufname = vim.fn.bufname()
          self.pick_child = {1}
          if buf.filetype == "harpoon" then
            self.f_name_result = "Harpoon"
          elseif buf.filetype == "TelescopePrompt" then
            self.f_name_result = "Telescope"
          elseif buf.filetype == "TelescopeResults" then
            self.f_name_result = "Telescope"
          elseif buf.filetype == "OverseerList" then
            self.f_name_result = "Telescope"
          elseif buf.buftype == "help" then
            self.f_name_result = "help:" .. vim.fn.fnamemodify(bufname, ":t:r")
          elseif buf.buftype == "terminal" then
            local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
            self.f_name_result = " " .. tname
          elseif vim.w.quickfix_title then
            self.f_name_result = vim.w.quickfix_title
          elseif bufname == "" then
            self.f_name_result = "[No Name]"
          else
            self.f_name_result = bufname
            self.pick_child = {1, 2, 3}
          end
        end,

        flexible = 2,
        {
          provider = function (self)
            return self.f_name_result
          end
        },
        {
          provider = function (self)
            return vim.fn.pathshorten(self.f_name_result, 2)
          end
        },
        {
          provider = function (self)
            return vim.fn.pathshorten(self.f_name_result, 1)
          end
        }
			}
			local BufferFlags = {
				{
					condition = function()
						return vim.bo.modified
					end,
					provider = " ",
					hl = function()
						return conditions.is_active() and { fg = "yellow" }
					end,
				},
				{
					condition = function()
						return not vim.bo.modifiable or vim.bo.readonly
					end,
					provider = " ",
				},
			}
			local Ruler = {
				-- %l = current line number
				-- %L = number of lines in the buffer
				-- %c = column number
				-- %P = percentage through file of displayed window
				provider = "%6(%l:%c%)",
			}
			local Diff2 = {
				condition = conditions.is_git_repo,
				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0
						or self.status_dict.removed ~= 0
						or self.status_dict.changed ~= 0
				end,
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and (" " .. count) .. " "
					end,
					hl = { fg = "git_add" },
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and (" " .. count) .. " "
					end,
					hl = { fg = "git_change" },
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and (" " .. count) .. " "
					end,
					hl = { fg = "git_del" },
				},
			}
			local Diff = {
				condition = conditions.is_git_repo,
				init = function(self)
					self.status_dict = vim.b.gitsigns_status_dict
					self.has_changes = self.status_dict.added ~= 0
						or self.status_dict.removed ~= 0
						or self.status_dict.changed ~= 0
				end,
				{
					provider = "(",
				},
				{
					provider = function(self)
						local count = self.status_dict.added or 0
						return count > 0 and ("+" .. count)
					end,
					hl = { fg = "git_add" },
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and ("~" .. count)
					end,
					hl = { fg = "git_change" },
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and ("-" .. count)
					end,
					hl = { fg = "git_del" },
				},
				{
					provider = ")",
				},
			}
			local Diagnostics = {

				condition = conditions.has_diagnostics,

				static = {
					error_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR],
					warn_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN],
					info_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO],
					hint_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT],
				},

				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { "DiagnosticChanged", "BufEnter" },

				-- {
				-- 	-- provider = "![",
				-- 	provider = " ",
				-- },
				{
					provider = function(self)
						return self.errors > 0 and (self.error_icon .. self.errors .. " ")
					end,
					hl = { fg = "diag_error" },
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
					end,
					hl = { fg = "diag_warn" },
				},
				{
					provider = function(self)
						return self.info > 0 and (self.info_icon .. self.info .. " ")
					end,
					hl = { fg = "diag_info" },
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.hint_icon .. self.hints)
					end,
					hl = { fg = "diag_hint" },
				},
				-- {
				-- 	-- provider = "]",
				-- 	provider = " ",
				-- },
			}
			local Spacer = { provider = " %= " }
			local Padding = { provider = " " }
			local Padding2 = { provider = "  " }
			local DAPMessages = {
				condition = function()
					local session = require("dap").session()
					return session ~= nil
				end,
        flexible = 1,
        {
          provider = function()
            return "  " .. require("dap").status()
          end,
        },
        {
          provider = function()
            return " "
          end,
        },
				hl = "Debug",
			}
			local Lsp = {
				provider = function()
					local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
					return #clients > 0 and " " .. #clients
				end,
				hl = { fg = "blue" },
			}
			local FileTypeIcon = {
				init = function(self)
					local bufname = vim.fn.bufname()
					local extension = vim.fn.fnamemodify(bufname, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(bufname, extension, { default = true })
				end,
				provider = function(self)
					return self.icon and (self.icon .. " ")
				end,
				hl = function(self)
					return conditions.is_active() and { fg = self.icon_color }
				end,
			}
			local FileType = {
				provider = function()
					return vim.bo.filetype ~= "" and vim.bo.filetype or "[No Type]"
				end,
			}
			local FileEncoding = {
				provider = function()
					local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc -- :h 'enc'
					return enc:upper()
				end,
				hl = function()
					return conditions.is_active() and { fg = "green" }
				end,
			}

			local FileFormat = {
				static = {
					encoding_tables = {
						unix = "LF",
						dos = "CRLF",
						mac = "CR",
					},
				},
				provider = function(self)
					local fmt = vim.bo.fileformat
					return self.encoding_tables[fmt]
				end,
				hl = function()
					return conditions.is_active() and { fg = "green" }
				end,
			}
			local Ender = {
				provider = "🮇",
				-- provider = '▕',
				hl = function(self)
					local color = self.mode_color(self)
					return { fg = color }
				end,
				update = {
					"ModeChanged",
					pattern = "*:*",
					callback = vim.schedule_wrap(function()
						vim.cmd("redrawstatus")
					end),
				},
			}
			local DefaultStatusLine = {
				ModeIndicator,
				Padding,
				{
					FileName,
					BufferFlags,
          hl = function()
            if vim.bo.modified and conditions.is_active() then
              return { fg = "yellow" }
            end
          end,
					{ provider = "%<" },
				},
				Padding2,
				Ruler,
				Padding,
				{
					flexible = 4,
					Diff2,
					Diff,
				},
				Diagnostics,
				Spacer,
				{
					flexible = 5,
					DAPMessages,
					{ provider = "" },
				},
				Padding2,
				Lsp,
				Padding2,
				FileEncoding,
				Padding2,
				FileFormat,
				Padding2,
				FileTypeIcon,
				FileType,
				Ender,
			}
			local InactiveStatusLine = {
				condition = conditions.is_not_active,
				Padding,
				{
					FileName,
					BufferFlags,
					{ provider = " %<" },
				},
				Spacer,
				FileEncoding,
				Padding2,
				FileFormat,
				Padding2,
				FileTypeIcon,
				FileType,
				Padding,
			}
			local StatusLine = {
				static = {
					mode_colors_map = {
						n = "blue",
						i = "green",
						v = "cyan",
						V = "cyan",
						["\22"] = "cyan",
						c = "red",
						s = "purple",
						S = "purple",
						["\19"] = "purple",
						R = "orange",
						r = "orange",
						["!"] = "red",
						t = "red",
					},
					mode_color = function(self)
						local mode = conditions.is_active() and vim.fn.mode() or "n"
						return self.mode_colors_map[mode]
					end,
				},
				hl = function()
					-- return "StatusLine"
					if conditions.is_active() then
						return "HeirLine"
					else
						return "StatusLineNC"
					end
				end,

				-- the first statusline with no condition, or which condition returns true is used.
				-- think of it as a switch case with breaks to stop fallthrough.
				fallthrough = false,

				InactiveStatusLine,
				DefaultStatusLine,
			}

			require("heirline").setup({
				statusline = StatusLine,
				opts = {
					colors = h_colors,
				},
			})
		end,
	},
}
