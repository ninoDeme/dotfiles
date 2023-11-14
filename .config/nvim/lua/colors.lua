local c = require('onedark.colors')

---@class colors
---@field bg '#1f2329',
---@field bg0 '#1f2329',
---@field bg1 "#282c34",
---@field bg2 "#30363f",
---@field bg3 "#323641",
---@field bg_alt '#282c34',
---@field bg_blue "#61afef",
---@field bg_d "#181b20",
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
local colors = c

colors.bg = colors.bg0
colors.bg_alt = colors.bg1

local highlights = {
  PmenuSel = { bg = colors.bg1 , fg = "NONE" },
  Pmenu = { fg = colors.fg, bg = colors.bg_d },

  CmpItemAbbrDeprecated = { fg = colors.light_grey, bg = "NONE", strikethrough = true },
  CmpItemAbbrMatch = { fg = colors.blue, bg = "NONE", bold = true, underline = true },
  CmpItemAbbrMatchFuzzy = { fg = colors.blue, bg = "NONE", bold = true, underline = true  },
  CmpItemMenu = { fg = colors.purple, bg = "NONE", italic = true },

  CmpItemKindField = { fg = "#EED8DA", bg = "#B5585F" },
  CmpItemKindProperty = { fg = "#EED8DA", bg = "#B5585F" },
  CmpItemKindEvent = { fg = "#EED8DA", bg = "#B5585F" },

  CmpItemKindText = { fg = "#f3ffeD", bg = "#7F9D63" },
  CmpItemKindEnum = { fg = "#f3ffeD", bg = "#7F9D63" },
  CmpItemKindKeyword = { fg = "#f3ffeD", bg = "#7F9D63" },

  CmpItemKindConstant = { fg = "#FFE592", bg = "#D4BB6C" },
  CmpItemKindConstructor = { fg = "#FFE592", bg = "#D4BB6C" },
  CmpItemKindReference = { fg = "#FFE592", bg = "#D4BB6C" },

  CmpItemKindFunction = { fg = "#EADFF0", bg = "#A377BF" },
  CmpItemKindStruct = { fg = "#EADFF0", bg = "#A377BF" },
  CmpItemKindClass = { fg = "#EADFF0", bg = "#A377BF" },
  CmpItemKindModule = { fg = "#EADFF0", bg = "#A377BF" },
  CmpItemKindOperator = { fg = "#EADFF0", bg = "#A377BF" },

  CmpItemKindVariable = { fg = "#C5CDD9", bg = "#7E8294" },
  CmpItemKindFile = { fg = "#C5CDD9", bg = "#7E8294" },

  CmpItemKindUnit = { fg = "#F5EBD9", bg = "#D4A959" },
  CmpItemKindSnippet = { fg = "#F5EBD9", bg = "#D4A959" },
  CmpItemKindFolder = { fg = "#F5EBD9", bg = "#D4A959" },

  CmpItemKindMethod = { fg = "#DDE5F5", bg = "#6C8ED4" },
  CmpItemKindValue = { fg = "#DDE5F5", bg = "#6C8ED4" },
  CmpItemKindEnumMember = { fg = "#DDE5F5", bg = "#6C8ED4" },

  CmpItemKindInterface = { fg = "#D8EEEB", bg = "#58B5A8" },
  CmpItemKindColor = { fg = "#D8EEEB", bg = "#58B5A8" },
  CmpItemKindTypeParameter = { fg = "#D8EEEB", bg = "#58B5A8" },

  DapBreakpoint = { fg = colors.red },
  DapBreakpointCondition = { fg = colors.red },
  DapLogPoint = { fg = colors.red },
  DapStopped = { fg = colors.green },
  DapStoppedLine = { bg = colors.bg2 },
  DapBreakpointRejected = { fg = colors.yellow },

  IndentBlanklineContextStart = { underline = false, bg = colors.bg1 },
  IblScopeChar = { link = "IblScope" },
  IblScopeFunction = { underline = false, bg = colors.bg1 },

  -- LirFloatNormal = { link = 'LirFloatNormal' },
  -- LirFloatBorder = { bg = colors.bg_d },
  -- LirFloatCurdirWindowNormal = { fg = colors.blue, bg = colors.bg_d },

  BqfPreviewFloat = { link = "FloatNormal" },
  FileModified = { fg = colors.yellow },
  FileLine = { link = "lualine_c_normal" },
  lualine_b_normal = { bg = colors.bg },

  TreesitterContext = { bg = colors.bg1 },

  -- Credit  https://astronvim.com/recipes/telescope_theme
  TelescopeBorder = { fg = colors.bg_alt, bg = colors.bg_d },
  TelescopeNormal = { bg = colors.bg_d },
  TelescopePreviewBorder = { fg = colors.bg, bg = colors.bg_d },
  TelescopePreviewNormal = { bg = colors.bg_d },
  TelescopePreviewTitle = { fg = colors.bg, bg = colors.green },
  TelescopePromptBorder = { fg = colors.bg_alt, bg = colors.bg_alt },
  TelescopePromptNormal = { fg = colors.fg, bg = colors.bg_alt },
  TelescopePromptPrefix = { fg = colors.red, bg = colors.bg_alt },
  TelescopePromptTitle = { fg = colors.bg, bg = colors.red },
  TelescopeResultsBorder = { fg = colors.bg_d, bg = colors.bg_d },
  TelescopeResultsNormal = { bg = colors.bg_d },
  TelescopeResultsTitle = { fg = colors.bg, bg = colors.blue },
}

highlights = vim.tbl_extend('force', highlights, require("hover").set_highlights(colors))

for key, val in pairs(highlights) do
  vim.api.nvim_set_hl(0, key, val)
end

return colors
