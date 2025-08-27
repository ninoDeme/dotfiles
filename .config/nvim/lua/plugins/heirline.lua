---shortens path by turning apple/orange -> a/orange
---@param path string
---@param sep string path separator
---@param max_len integer maximum length of the full filename string
---@return string
local function shorten_path(path, sep, max_len)
	local len = #path
	if len <= max_len then
		return path
	end

	local segments = vim.split(path, sep)
	for idx = 1, #segments - 1 do
		if len <= max_len then
			break
		end

		local segment = segments[idx]
		local shortened = segment:sub(1, vim.startswith(segment, ".") and 2 or 1)
		segments[idx] = shortened
		len = len - (#segment - #shortened)
	end

	return table.concat(segments, sep)
end

return {
	{
		"rebelot/heirline.nvim",
    -- enabled = false,
		-- You can optionally lazy-load heirline on UiEnter
		-- to make sure all required plugins and colorschemes are loaded before setup
		event = "UiEnter",
		config = function()
			local conditions = require("heirline.conditions")

      local use_icons = false

			local FileName = {
				init = function(self)
					local buf = vim.bo
					local bufname = vim.fn.bufname()
					self.pick_child = { 1 }
					if buf.filetype == "harpoon" then
						self.f_name_result = "Harpoon"
					elseif buf.filetype == "TelescopePrompt" then
						self.f_name_result = "Telescope"
					elseif buf.filetype == "TelescopeResults" then
						self.f_name_result = "Telescope"
					elseif buf.filetype == "OverseerList" then
						self.f_name_result = "Overseer"
					elseif buf.buftype == "help" then
						self.f_name_result = "help:" .. vim.fn.fnamemodify(bufname, ":t:r")
					elseif buf.buftype == "terminal" then
						local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
						self.f_name_result = tname
					elseif vim.w.quickfix_title then
						self.f_name_result = vim.w.quickfix_title
					elseif bufname == "" then
						self.f_name_result = "[No Name]"
					else
						self.f_name_result = bufname
						self.pick_child = { 1, 2, 3 }
					end
				end,

				flexible = 2,
				{
					provider = function(self)
						return self.f_name_result
					end,
				},
				{
					provider = function(self)
						return shorten_path(self.f_name_result, '/', 40)
					end,
				},
				{
					provider = function(self)
						return shorten_path(self.f_name_result, '/', 20)
					end,
				},
			}
			local BufferFlags = {
				{
					condition = function()
						return vim.bo.modified
					end,
					provider = use_icons and " " or " [+]",
					-- hl = function()
					-- 	return conditions.is_active() and { fg = "yellow" }
					-- end,
				},
				{
					condition = function()
						return not vim.bo.filetype == "OverseerList" and (not vim.bo.modifiable or vim.bo.readonly)
					end,
					provider = use_icons and " " or " [RO]",
				},
			}
			local Ruler = {
				-- %l = current line number
				-- %L = number of lines in the buffer
				-- %c = column number
				-- %P = percentage through file of displayed window
				provider = "%6(%l:%c%)",
			}
			local Diff = {
				condition = function (self)
				    return (vim.b.gitsigns_status or "") ~= ""
				end,
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
					hl = "DiffAdd",
				},
				{
					provider = function(self)
						local count = self.status_dict.changed or 0
						return count > 0 and ("~" .. count)
					end,
					hl = "DiffChange",
				},
				{
					provider = function(self)
						local count = self.status_dict.removed or 0
						return count > 0 and ("-" .. count)
					end,
					hl = "DiffDelete",
				},
				{
					provider = ")",
				},
			}
			local Diagnostics = {

				condition = conditions.has_diagnostics,

				static = use_icons and {
					error_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR],
					warn_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN],
					info_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO],
					hint_icon = vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT],
				} or {
					error_icon = "E:",
					warn_icon = "W:",
					info_icon = "I:",
					hint_icon = "H:"
        },

				init = function(self)
					self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
					self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
					self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
					self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
				end,

				update = { "DiagnosticChanged", "BufEnter" },

				{
					-- provider = "![",
					provider = use_icons and nil or " ",
				},
				{
					provider = function(self)
						return self.errors > 0 and (self.error_icon .. self.errors .. " ")
					end,
					hl = "DiagnosticError",
				},
				{
					provider = function(self)
						return self.warnings > 0 and (self.warn_icon .. self.warnings .. " ")
					end,
					hl = "DiagnosticWarn",
				},
				{
					provider = function(self)
						return self.info > 0 and (self.info_icon .. self.info .. " ")
					end,
					hl = "DiagnosticInfo",
				},
				{
					provider = function(self)
						return self.hints > 0 and (self.hint_icon .. self.hints)
					end,
					hl = "DiagnosticHint",
				},
				-- {
				-- 	-- provider = "]",
				-- 	provider = " ",
				-- },
			}
			local Spacer = { provider = " %= " }
			local Padding = { provider = " " }
			local Padding2 = {
			  flexible = 0,
        {
          provider = "  "
        },
        Padding
			}
			local Lsp = {
				provider = function()
					local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
					return #clients > 0 and (use_icons and " " or "LSP:" ).. #clients
				end,
				-- hl = { fg = "blue" },
			}
			local FileTypeIcon = {
        condition = function() return use_icons end,
				init = function(self)
					local bufname = vim.fn.bufname()
					local extension = vim.fn.fnamemodify(bufname, ":e")
					self.icon, self.icon_color =
						require("nvim-web-devicons").get_icon_color(bufname, extension, { default = true })
				end,
				provider = function(self)
					return self.icon and (self.icon .. " ")
				end,
				-- hl = function(self)
				-- 	return conditions.is_active() and { fg = self.icon_color }
				-- end,
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
				-- hl = function()
				-- 	return conditions.is_active() and { fg = "green" }
				-- end,
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
				-- hl = function()
				-- 	return conditions.is_active() and { fg = "green" }
				-- end,
			}
			local DefaultStatusLine = {
				-- ModeIndicator,
				Padding,
				{
					FileName,
					BufferFlags,
					hl = function()
						-- if vim.bo.modified and conditions.is_active() then
						-- 	return { fg = "yellow" }
						-- end
					end,
					{ provider = "%<" },
				},
				Padding2,
				Ruler,
				Padding,
			  Diff,
				Diagnostics,
				Spacer,
				Lsp,
				Padding2,
				FileEncoding,
				Padding2,
				FileFormat,
				Padding2,
				FileTypeIcon,
				FileType,
				Padding,
				-- Ender,
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
						return "StatusLine"
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

			vim.opt.showtabline = 1
			require("heirline").setup({
				statusline = StatusLine,

				-- opts = {
				-- 	colors = h_colors,
				-- },
			})
		end,
	},
}
