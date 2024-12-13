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

local escape_lua_pattern = function(s)
	return string.gsub(s, "[%$%^%(%)%%%.%[%]*+%-%?]", "%%%1")
end

local function format_buffer_name(bufnr, rel)
	local buf = vim.bo[bufnr]
	local bufname = vim.fn.bufname(bufnr)
	if buf.filetype == "harpoon" then
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
		local tname, _ = vim.api.nvim_buf_get_name(0):gsub(".*:", "")
		return tname
	elseif bufname == "" then
		return "[No Name]"
	else
		local result = string.gsub(vim.fn.fnamemodify(bufname, ":p"), escape_lua_pattern(rel) .. "/", "", 1)
		return shorten_path(result, "/", 60)
	end
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
			local utils = require("heirline.utils")

			local h_colors = require("colors").heirline_colors()

      local use_icons = false

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
						ntT = "Normal!",
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
						nt = "N",
						ntT = "Nt",
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
					hl = function()
						return conditions.is_active() and { fg = "yellow" }
					end,
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
				condition = function (self)
				    return conditions.is_git_repo() and self.has_changes
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
			local Padding2 = {
			  flexible = 0,
        {
          provider = "  "
        },
        Padding
			}
			local DAPMessages = {
				condition = function()
					local session = require("dap").session()
					return session ~= nil
				end,
				flexible = 1,
				{
					provider = function()
						return (use_icons and "  " or "DAP " ).. require("dap").status()
					end,
				},
				{
					provider = function()
						return use_icons and " " or "DAP"
					end,
				},
				hl = "Debug",
			}
			local Lsp = {
				provider = function()
					local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })
					return #clients > 0 and (use_icons and " " or "LSP:" ).. #clients
				end,
				hl = { fg = "blue" },
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
        use_icons and {
					flexible = 4,
					Diff2,
					Diff,
				} or Diff,
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

      local WorkDir = {
        init = function(self)
          self.icon = (vim.fn.haslocaldir(0) == 1 and "l" or "") .. " " .. (use_icons and " " or "")
          local cwd = vim.fn.getcwd(0)
          self.cwd = vim.fn.fnamemodify(cwd, ":~")
        end,
        hl = { fg = "blue", bold = false },

        flexible = 1,

        {
          -- evaluates to the full-lenth path
          provider = function(self)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            local cwd = shorten_path(self.cwd, "/", 60)
            return self.icon .. cwd .. trail .." "
          end,
        },
        {
          -- evaluates to the shortened path
          provider = function(self)
            local cwd = shorten_path(self.cwd, "/", 30)
            local trail = self.cwd:sub(-1) == "/" and "" or "/"
            return self.icon .. cwd .. trail .. " "
          end,
        },
        {
          -- evaluates to "", hiding the component
          provider = "",
        }
      }

			local Tabpage = {
				{
					provider = function(self)
						return "%" .. self.tabnr .. "T "
					end,
				},
				{
					provider = function(self)
						return self.tabnr
					end,
					hl = function(self)
						if self.is_active then
							return "TabLineSelTitle"
						end
						return "TabLineTitle"
					end,
				},
				{
					provider = " - ",
				},
				{
					provider = function(self)
						local not_hidden_bufs = self.not_hidden_bufs or {}
						return string.format(
							"%s",
							(not_hidden_bufs[1] or "")
							-- (not_hidden_bufs[2] or "")
							-- (not_hidden_bufs[3] or "")
						)
					end,
				},
				{
					condition = function(self)
						return self.any_modified
					end,
					provider = "  ",
					hl = function(self)
						if self.is_active then
							return "TabLineSelModified"
						end
						return "TabLineModified"
					end,
				},
				{
					condition = function(self)
						return #self.not_hidden_bufs > 1
					end,
					provider = function(self)
						local not_hidden_bufs = self.not_hidden_bufs
						return "[+" .. tostring(#not_hidden_bufs - 1) .. "] "
					end,
				},
				init = function(self)
					local tabnr = self.tabnr
					local tab_cwd = vim.fn.getcwd(-1, tabnr)
					local buflist = vim.fn.tabpagebuflist(tabnr)
					local buflist_without_duplicates = {}

					local hash = {}
					for _, v in ipairs(buflist) do
						if not hash[v] then
							buflist_without_duplicates[#buflist_without_duplicates + 1] = v
							hash[v] = true
						end
					end

					local winnr = vim.fn.tabpagewinnr(tabnr)
					local curr_bufr = buflist[winnr]
					local not_hidden_bufs = { format_buffer_name(curr_bufr, tab_cwd) .. " " }
					self.any_modified = false
					for _, bufnr in ipairs(buflist_without_duplicates) do
						local buf = vim.bo[bufnr]
						if buf.modified then
							self.any_modified = true
						end
						if bufnr ~= curr_bufr and buf.bufhidden == "" then
							table.insert(not_hidden_bufs, format_buffer_name(bufnr, tab_cwd) .. " ")
						end
					end
					self.not_hidden_bufs = not_hidden_bufs
				end,
				hl = function(self)
					if self.is_active then
						return "TabLineSel"
					else
						return "TabLine"
					end
				end,
			}

			local TabpageClose = {
				provider = "%999X  %X",
				hl = "TabLine",
			}

			local TabPages = {
				-- only show this component if there's 2 or more tabpages
				-- condition = function()
				-- 	return #vim.api.nvim_list_tabpages() >= 2
				-- end,
				utils.make_tablist(Tabpage),
			}

			local Branch = {
				condition = conditions.is_git_repo,
				provider = function()
					-- return " " .. vim.b.gitsigns_head .. " "
					return " " .. vim.b.gitsigns_head .. " "
				end,
				hl = "TabLineBranch",
			}

			local Tasks = {
				condition = function()
					local ok, _ = pcall(require, "overseer")
					if ok then
						return true
					end
				end,
				provider = function(self)
					local tasks = require("overseer").task_list.list_tasks()
					if tasks == nil or #tasks == 0 then
						return ""
					end
					return "  " .. tostring(#tasks) .. "  "
				end,

				hl = { fg = "blue" },
			}

			local TabLine = {
				TabPages,
        { provider = "%=" },
        {
          Tasks,
          {
            flexible = 5,
            DAPMessages,
            { provider = "" },
          },
          Padding2,
          WorkDir,
          Padding,
          Branch,
          TabpageClose,
          hl = "TabLineFill",
        },
      }

			vim.opt.showtabline = 2
			require("heirline").setup({
				statusline = StatusLine,
				tabline = TabLine,
				opts = {
					colors = h_colors,
				},
			})
		end,
	},
}
