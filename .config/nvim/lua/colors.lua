-- get a hex list of gruvbox colors based on current bg and constrast config

---@class Colors
---@field bg0 '#1f2329',
---@field bg1 "#282c34",
---@field bg2 "#30363f",
---@field bg3 "#323641",
-- ---@field bg_d "#181b20",
---@field bg_blue "#61afef",
---@field bg_yellow "#e8c88c",
---@field black "#0e1013",
---@field blue "#4fa6ed",
---@field cyan "#48b0bd",
---@field dark_cyan "#266269",
---@field dark_purple "#7e3992",
---@field dark_red "#8b3434",
---@field dark_yellow "#835d1a",
---@field diff_add "#272e23",
---@field diff_change "#172a3a",
---@field diff_delete "#2d2223",
---@field diff_text "#274964",
---@field fg "#a0a8b7",
---@field green "#8ebd6b",
---@field grey "#535965",
---@field light_grey "#7a818e",
---@field none "none",
---@field orange "#cc9057",
---@field purple "#bf68d9",
---@field red "#e55561",
---@field yellow "#e2b86b"
---@deprecated

---@alias ThemeStyle 'onedark' | 'gruvbox' Theme

---@class M
---@field colors Colors
---@field theme ThemeStyle
local M = {}

--- Get Border Style
---@param theme ThemeStyle Theme
M.setup = function(theme)
  M.theme = theme
	local highlights = {}
	-- if theme == "onedark" then
	-- 	M.colors = require("onedark.colors")
	-- elseif theme == "gruvbox" then
	-- 	M.colors = get_colors(require("gruvbox").palette, require("gruvbox").config)
	-- end

	highlights = vim.tbl_extend("keep", highlights, {

		-- DapBreakpoint = { fg = M.colors.red },
		DapBreakpoint = { ctermfg = 12 },
		-- DapBreakpointCondition = { fg = M.colors.red },
		DapBreakpointCondition = { ctermfg = 12 },
		-- DapLogPoint = { fg = M.colors.red },
		DapLogPoint = { ctermfg = 12 },
		-- DapStopped = { fg = M.colors.green },
		DapStopped = { ctermfg = 10 },
		-- DapStoppedLine = { bg = M.colors.bg2 },
		DapStoppedLine = { link = 'Visual' },
		-- DapBreakpointRejected = { fg = M.colors.yellow },
		DapBreakpointRejected = { ctermfg = 14 },

		-- IndentBlanklineContextStart = { underline = false, bg = M.colors.bg1 },
		-- -- IblScopeChar = { link = "IblScope" },
		-- -- IblScopeFunction = { underline = false, bg = M.colors.bg1 },

		BqfPreviewFloat = { link = "FloatNormal" },

		-- FileModified = { fg = M.colors.yellow },
		FileModified = { ctermfg = 14 },
		FileLine = { link = "lualine_c_normal" },

		lualine_b_normal = { link = "lualine_c_normal" },

		TreesitterContext = { link = "Visual" },

		-- Credit  https://astronvim.com/recipes/telescope_theme
		-- TelescopeBorder = { fg = M.colors.bg1, bg = M.colors.bg_d },
		-- TelescopeNormal = { bg = M.colors.bg_d },
		-- TelescopePreviewBorder = { fg = M.colors.bg0, bg = M.colors.bg_d },
		-- TelescopePreviewNormal = { bg = M.colors.bg_d },
		-- TelescopePreviewTitle = { fg = M.colors.bg0, bg = M.colors.green },
		-- TelescopePromptBorder = { fg = M.colors.bg1, bg = M.colors.bg1 },
		-- TelescopePromptNormal = { fg = M.colors.fg, bg = M.colors.bg1 },
		-- TelescopePromptPrefix = { fg = M.colors.red, bg = M.colors.bg1 },
		-- TelescopePromptTitle = { fg = M.colors.bg0, bg = M.colors.red },
		-- TelescopeResultsBorder = { fg = M.colors.bg_d, bg = M.colors.bg_d },
		-- TelescopeResultsNormal = { bg = M.colors.bg_d },
		-- TelescopeResultsTitle = { fg = M.colors.bg0, bg = M.colors.blue },

		TelescopePreviewBorder = { link = 'FloatBorder' },
		TelescopePromptBorder = { link = 'FloatBorder' },
		TelescopeResultsBorder = { link = 'FloatBorder' },

		-- OilSize = { fg = M.colors.green },
		-- OilMtime = { fg = M.colors.blue },

		OilSize = { ctermfg = 10 },
		OilMtime = { ctermfg = 9 },

    -- WinBarNC = { bold = false, bg = M.colors.bg_d },
    -- WinBar = { bold = false, bg = M.colors.bg_d },
    -- WinBarPathRel = { bold = false, fg = M.colors.blue, bg = M.colors.bg_d },

    WinBarNC = { link = 'Normal' },
    WinBar = { link = 'Normal' },
    WinBarPathRel = vim.api.nvim_get_hl(0, {name = 'Title'}),

    QuickFixLine = { fg = 'none', underline = true }
	})

  highlights.WinBarPathRel.bold = true

	highlights = vim.tbl_extend("force", highlights, require("hover").set_highlights(M.colors))

	for key, val in pairs(highlights) do
		vim.api.nvim_set_hl(0, key, val)
	end
end

return M
