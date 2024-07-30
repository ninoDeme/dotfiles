local M = {}

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
    return shorten_path(result, '/', 60)
	end
end

local function make_hl(raw, hl_name, default_hl)
	return string.format("%%#%s%s#%s%%#%s#", default_hl, hl_name, raw, default_hl)
end

M.setup = function()
	function MAKE_TAB_LINE()
		local tabline = ""
		local current_tab_page = vim.api.nvim_get_current_tabpage()
		for _, tab_handle in ipairs(vim.api.nvim_list_tabpages()) do
			local tabnr = vim.api.nvim_tabpage_get_number(tab_handle)
			local tab_cwd = vim.fn.getcwd(-1, tabnr)
			local buflist = vim.fn.tabpagebuflist(tabnr)
			local default_hl = tab_handle == current_tab_page and "TabLineSel" or "TabLine"
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
			local modified = ""
			local not_hidden_bufs = { format_buffer_name(curr_bufr, tab_cwd) .. " " }
			for _, bufnr in ipairs(buflist_without_duplicates) do
				local buf = vim.bo[bufnr]
				if buf.modified then
					modified = make_hl("  ", "Modified", default_hl)
				end
				if bufnr ~= curr_bufr and buf.bufhidden == "" then
					table.insert(not_hidden_bufs, format_buffer_name(bufnr, tab_cwd) .. " ")
				end
			end
			local buffers_length = ""
			if #not_hidden_bufs > 3 then
				buffers_length = make_hl("[+" .. tostring(#not_hidden_bufs - 3) .. "] ", "", default_hl)
			end
			tabline = string.format(
				"%s%%#%s#%%%iT %s - %s%s%s%s%s%%T",
				tabline,
				default_hl,
				tabnr,
				make_hl(tostring(tabnr), "Title", default_hl),
				buffers_length,
				(not_hidden_bufs[1] or ""),
				(not_hidden_bufs[2] or ""),
				(not_hidden_bufs[3] or ""),
				modified
			)
		end
		local git_head = vim.g.gitsigns_head or ""
		if git_head ~= "" then
			git_head = " " .. git_head .. " "
		end
		tabline = tabline .. "%#TabLineFill# %= %#TabLineBranch#" .. git_head
		return tabline
	end

	-- vim.opt.tabline = "%{%v:lua.MAKE_TAB_LINE()%}"
	vim.opt.showtabline = 2
end

return M

-- vim: ts=2 sts=2 sw=2 et
