local M = {}

--- @class base_30
--- @field white string (default: "#abb2bf")
--- @field darker_black string (default: "#1b1f27")
--- @field black string (default: "#1e222a")
--- @field black2 string (default: "#252931")
--- @field one_bg string (default: "#282c34")
--- @field one_bg2 string (default: "#353b45")
--- @field one_bg3 string (default: "#373b43")
--- @field grey string (default: "#42464e")
--- @field grey_fg string (default: "#565c64")
--- @field grey_fg2 string (default: "#6f737b")
--- @field light_grey string (default: "#6f737b")
--- @field red string (default: "#e06c75")
--- @field baby_pink string (default: "#DE8C92")
--- @field pink string (default: "#ff75a0")
--- @field line string (default: "#31353d")
--- @field green string (default: "#98c379")
--- @field vibrant_green string (default: "#7eca9c")
--- @field nord_blue string (default: "#81A1C1")
--- @field blue string (default: "#61afef")
--- @field yellow string (default: "#e7c787")
--- @field sun string (default: "#EBCB8B")
--- @field purple string (default: "#de98fd")
--- @field dark_purple string (default: "#c882e7")
--- @field teal string (default: "#519aba")
--- @field orange string (default: "#fca2aa")
--- @field cyan string (default: "#a3b8ef")
--- @field statusline_bg string (default: "#22262e")
--- @field lightbg string (default: "#2d3139")
--- @field pmenu_bg string (default: "#61afef")
--- @field folder_bg string (default: "#61afef")

M.setup = function()
  local highlights = {}

  --- @type base_30
  local colors = require("base46").get_theme_tb("base_30")

  -- if theme == "onedark" then
  -- 	M.colors = require("onedark.colors")
  -- elseif theme == "gruvbox" then
  -- 	M.colors = get_colors(require("gruvbox").palette, require("gruvbox").config)
  -- end

  local statusline_hl = vim.api.nvim_get_hl(0, { name = 'lualine_c_normal' })
  highlights = vim.tbl_extend("keep", highlights, {

    -- DapBreakpoint = { fg = M.colors.red },
    DapBreakpoint = { ctermfg = "Red", fg = colors.red },
    -- DapBreakpointCondition = { fg = M.colors.red },
    DapBreakpointCondition = { ctermfg = "Red", fg = colors.red },
    -- DapLogPoint = { fg = M.colors.red },
    DapLogPoint = { ctermfg = "Red", fg = colors.red },
    -- DapStopped = { fg = M.colors.green },
    DapStopped = { ctermfg = "Green", fg = colors.green },
    -- DapStoppedLine = { bg = M.colors.bg2 },
    DapStoppedLine = { link = "Visual" },
    -- DapBreakpointRejected = { fg = M.colors.yellow },
    DapBreakpointRejected = { ctermfg = "Yellow", fg = colors.yellow },

    -- IndentBlanklineContextStart = { underline = false, bg = M.colors.bg1 },
    -- -- IblScopeChar = { link = "IblScope" },
    -- -- IblScopeFunction = { underline = false, bg = M.colors.bg1 },

    BqfPreviewFloat = { link = "FloatNormal" },

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

    TelescopePreviewBorder = { link = "FloatBorder" },
    TelescopePromptBorder = { link = "FloatBorder" },
    TelescopeResultsBorder = { link = "FloatBorder" },

    -- OilSize = { fg = M.colors.green },
    -- OilMtime = { fg = M.colors.blue },

    OilSize = { fg = colors.green },
    OilMtime = { ctermfg = "LightBlue", fg = colors.blue },

    -- WinBarNC = { bold = false, bg = M.colors.bg_d },
    -- WinBar = { bold = false, bg = M.colors.bg_d },
    -- WinBarPathRel = { bold = false, fg = M.colors.blue, bg = M.colors.bg_d },

    lualine_file_modified = { fg = colors.yellow, bg = statusline_hl.bg },

    lualine_lsp = { fg = colors.blue, bg = statusline_hl.bg },
    lualine_encoding = { fg = colors.green, bg = statusline_hl.bg },
    lualine_line_ending = { fg = colors.green, bg = statusline_hl.bg },
    lualine_branch = { fg = colors.purple, bg = statusline_hl.bg },

    WinBarNC = { link = "Normal" },
    WinBar = { link = "Normal" },
    WinBarPathRel = vim.api.nvim_get_hl(0, { name = "Title" }),

    QuickFixLine = { fg = "none", underline = true },
  })

  highlights.WinBarPathRel.bold = true

  highlights = vim.tbl_extend("force", highlights, require("hover").set_highlights(M.colors))

  for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
  end
end

return M
