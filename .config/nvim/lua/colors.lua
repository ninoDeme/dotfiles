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
---
--- @class base_16
--- @field base00 string "#1e222a" normal background
--- @field base01 string "#353b45"
--- @field base02 string "#3e4451"
--- @field base03 string "#545862"
--- @field base04 string "#565c64"
--- @field base05 string "#abb2bf" normal foreground
--- @field base06 string "#b6bdca"
--- @field base07 string "#c8ccd4"
--- @field base08 string "#e06c75"
--- @field base09 string "#d19a66"
--- @field base0A string "#e5c07b"
--- @field base0B string "#98c379"
--- @field base0C string "#56b6c2"
--- @field base0D string "#61afef"
--- @field base0E string "#c678dd"
--- @field base0F string "#be5046"

M.setup = function()
  local highlights = {}

  --- @type base_30
  local colors = require("base46").get_theme_tb("base_30")
  --- @type base_16
  local theme = require("base46").get_theme_tb("base_16")

  highlights = vim.tbl_extend("keep", highlights, {

    DapBreakpoint = { ctermfg = "Red", fg = colors.red },
    DapBreakpointCondition = { ctermfg = "Red", fg = colors.red },
    DapLogPoint = { ctermfg = "Red", fg = colors.red },
    DapStopped = { ctermfg = "Green", fg = colors.green },
    DapStoppedLine = { link = "Visual" },
    DapBreakpointRejected = { ctermfg = "Yellow", fg = colors.yellow },

    BqfPreviewFloat = { link = "FloatNormal" },

    TreesitterContext = { bg = colors.black2 },

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

    -- TelescopePreviewBorder = { link = "FloatBorder" },
    -- TelescopePromptBorder = { link = "FloatBorder" },
    -- TelescopeResultsBorder = { link = "FloatBorder" },
    --
    DiagnosticUnderlineError = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg },
    DiagnosticUnderlineWarn = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg },
    DiagnosticUnderlineInfo = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg },
    DiagnosticUnderlineHint = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg },
    DiagnosticUnderlineOk = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticOk" }).fg },

    OilSize = { fg = colors.green },
    OilMtime = { ctermfg = "LightBlue", fg = colors.blue },

    TabLineModified = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false }),
    TabLineSelModified = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false }),
    TabLineTitle = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false }),
    TabLineSelTitle = vim.api.nvim_get_hl(0, { name = 'TabLineSel', link = false }),

    TabLineBranch = { fg = colors.purple, bg = vim.api.nvim_get_hl(0, { name = 'TabLineFill', link = false }).bg },

    WinBarNC = { link = "Normal" },
    WinBar = { link = "Normal" },
    WinBarPathRel = vim.api.nvim_get_hl(0, { name = "Title" }),

    QuickFixLine = { fg = "none", underline = true, sp = theme.base05 },

    HeirLine = { bg = colors.statusline_bg },

    StatusLine = { link = "StatusLineNC" }
  })

  highlights.WinBarPathRel.bold = true
  highlights.TabLineModified.fg = colors.yellow
  highlights.TabLineTitle.fg = colors.blue
  highlights.TabLineSelModified.fg = colors.yellow
  highlights.TabLineSelTitle.fg = colors.blue

  highlights = vim.tbl_extend("force", highlights, require("hover").set_highlights(M.colors))

  for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
  end
end

M.heirline_colors = function ()
  --- @type base_30
  local colors = require("base46").get_theme_tb("base_30")
  --- @type base_16
  local theme = require("base46").get_theme_tb("base_16")

  local heirline_utils = require("heirline.utils")
  return {
    bright_bg = theme.base01,
    bright_fg = theme.base06,
    red = colors.red,
    dark_red = theme.base0F,
    green = colors.green,
    blue = colors.blue,
    gray = colors.grey,
    yellow = colors.yellow,
    orange = colors.orange,
    purple = colors.purple,
    cyan = colors.cyan,
    diag_warn = heirline_utils.get_highlight("DiagnosticWarn").fg,
    diag_error = heirline_utils.get_highlight("DiagnosticError").fg,
    diag_hint = heirline_utils.get_highlight("DiagnosticHint").fg,
    diag_info = heirline_utils.get_highlight("DiagnosticInfo").fg,
    git_del = heirline_utils.get_highlight("Removed").fg,
    git_add = heirline_utils.get_highlight("Added").fg,
    git_change = heirline_utils.get_highlight("Changed").fg,
  }
end

M.update_colors = function ()
  M.setup()
  -- require("heirline").load_colors(M.heirline_colors())
end

return M
