-- get a hex list of gruvbox colors based on current bg and constrast config
local function get_colors(p, config)
	for color, hex in pairs(config.palette_overrides) do
		p[color] = hex
	end

	local bg = vim.o.background
	local contrast = config.contrast

	local color_groups = {
		dark = {
			bg_d = p.dark0_hard,
			bg0 = p.dark0,
			bg1 = p.dark1,
			bg2 = p.dark2,
			bg3 = p.dark3,
			bg4 = p.dark4,
			fg0 = p.light0,
			fg1 = p.light1,
			fg2 = p.light2,
			fg3 = p.light3,
			fg4 = p.light4,
			red = p.bright_red,
			green = p.bright_green,
			yellow = p.bright_yellow,
			blue = p.bright_blue,
			purple = p.bright_purple,
			aqua = p.bright_aqua,
			orange = p.bright_orange,
			neutral_red = p.neutral_red,
			neutral_green = p.neutral_green,
			neutral_yellow = p.neutral_yellow,
			neutral_blue = p.neutral_blue,
			neutral_purple = p.neutral_purple,
			neutral_aqua = p.neutral_aqua,
			dark_red = p.dark_red,
			dark_green = p.dark_green,
			dark_aqua = p.dark_aqua,
			gray = p.gray,
		},
		light = {
			bg0 = p.light0,
			bg1 = p.light1,
			bg2 = p.light2,
			bg3 = p.light3,
			bg4 = p.light4,
			fg0 = p.dark0,
			fg1 = p.dark1,
			fg2 = p.dark2,
			fg3 = p.dark3,
			fg4 = p.dark4,
			red = p.faded_red,
			green = p.faded_green,
			yellow = p.faded_yellow,
			blue = p.faded_blue,
			purple = p.faded_purple,
			aqua = p.faded_aqua,
			orange = p.faded_orange,
			neutral_red = p.neutral_red,
			neutral_green = p.neutral_green,
			neutral_yellow = p.neutral_yellow,
			neutral_blue = p.neutral_blue,
			neutral_purple = p.neutral_purple,
			neutral_aqua = p.neutral_aqua,
			dark_red = p.light_red,
			dark_green = p.light_green,
			dark_aqua = p.light_aqua,
			gray = p.gray,
		},
	}

	if contrast ~= nil and contrast ~= "" then
		color_groups[bg].bg0 = p[bg .. "0_" .. contrast]
		color_groups[bg].dark_red = p[bg .. "_red_" .. contrast]
		color_groups[bg].dark_green = p[bg .. "_green_" .. contrast]
		color_groups[bg].dark_aqua = p[bg .. "_aqua_" .. contrast]
	end

	return color_groups[bg]
end

---@class Colors
---@field bg0 '#1f2329',
---@field bg1 "#282c34",
---@field bg2 "#30363f",
---@field bg3 "#323641",
---@field bg_d "#181b20",
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
	if theme == "onedark" then
		M.colors = require("onedark.colors")
	elseif theme == "gruvbox" then
		M.colors = get_colors(require("gruvbox").palette, require("gruvbox").config)
	end

	highlights = vim.tbl_extend("keep", highlights, {

		DapBreakpoint = { fg = M.colors.red },
		DapBreakpointCondition = { fg = M.colors.red },
		DapLogPoint = { fg = M.colors.red },
		DapStopped = { fg = M.colors.green },
		DapStoppedLine = { bg = M.colors.bg2 },
		DapBreakpointRejected = { fg = M.colors.yellow },

		IndentBlanklineContextStart = { underline = false, bg = M.colors.bg1 },
		IblScopeChar = { link = "IblScope" },
		IblScopeFunction = { underline = false, bg = M.colors.bg1 },

		-- LirFloatNormal = { link = 'LirFloatNormal' },
		-- LirFloatBorder = { bg = M.colors.bg_d },
		-- LirFloatCurdirWindowNormal = { fg = M.colors.blue, bg = M.colors.bg_d },

		BqfPreviewFloat = { link = "FloatNormal" },
		FileModified = { fg = M.colors.yellow },
		FileLine = { link = "lualine_c_normal" },
		lualine_b_normal = { bg = M.colors.bg0 },

		TreesitterContext = { bg = M.colors.bg1 },

		-- Credit  https://astronvim.com/recipes/telescope_theme
		TelescopeBorder = { fg = M.colors.bg1, bg = M.colors.bg_d },
		TelescopeNormal = { bg = M.colors.bg_d },
		TelescopePreviewBorder = { fg = M.colors.bg0, bg = M.colors.bg_d },
		TelescopePreviewNormal = { bg = M.colors.bg_d },
		TelescopePreviewTitle = { fg = M.colors.bg0, bg = M.colors.green },
		TelescopePromptBorder = { fg = M.colors.bg1, bg = M.colors.bg1 },
		TelescopePromptNormal = { fg = M.colors.fg, bg = M.colors.bg1 },
		TelescopePromptPrefix = { fg = M.colors.red, bg = M.colors.bg1 },
		TelescopePromptTitle = { fg = M.colors.bg0, bg = M.colors.red },
		TelescopeResultsBorder = { fg = M.colors.bg_d, bg = M.colors.bg_d },
		TelescopeResultsNormal = { bg = M.colors.bg_d },
		TelescopeResultsTitle = { fg = M.colors.bg0, bg = M.colors.blue },

		OilSize = { fg = M.colors.green },
		OilMtime = { fg = M.colors.blue },
	})

	highlights = vim.tbl_extend("force", highlights, require("hover").set_highlights(M.colors))

	for key, val in pairs(highlights) do
		vim.api.nvim_set_hl(0, key, val)
	end
end

return M
