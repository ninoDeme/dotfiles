local c = require('onedark.colors')

c.bg = c.bg0
c.bg_alt = c.bg1
-- vim.print(vim.inspect(c))

local colors = {
  PmenuSel = { bg = "#282C34", fg = "NONE" },
  Pmenu = { fg = "#C5CDD9", bg = "#22252A" },

  CmpItemAbbrDeprecated = { fg = "#7E8294", bg = "NONE", strikethrough = true },
  CmpItemAbbrMatch = { fg = "#82AAFF", bg = "NONE", bold = true },
  CmpItemAbbrMatchFuzzy = { fg = "#82AAFF", bg = "NONE", bold = true },
  CmpItemMenu = { fg = "#C792EA", bg = "NONE", italic = true },

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

  LirFloatNormal = { bg = c.bg_d },
  LirFloatBorder = { bg = c.bg_d },
  LirFloatCurdirWindowNormal = { fg = c.blue, bg = c.bg_d },

  FileModified = { fg = c.yellow },
  FileLine = { link = "lualine_c_normal" },

  -- Credit  https://astronvim.com/recipes/telescope_theme
  TelescopeBorder = { fg = c.bg_alt, bg = c.bg_d },
  TelescopeNormal = { bg = c.bg_d },
  TelescopePreviewBorder = { fg = c.bg, bg = c.bg_d },
  TelescopePreviewNormal = { bg = c.bg_d },
  TelescopePreviewTitle = { fg = c.bg, bg = c.green },
  TelescopePromptBorder = { fg = c.bg_alt, bg = c.bg_alt },
  TelescopePromptNormal = { fg = c.fg, bg = c.bg_alt },
  TelescopePromptPrefix = { fg = c.red, bg = c.bg_alt },
  TelescopePromptTitle = { fg = c.bg, bg = c.red },
  TelescopeResultsBorder = { fg = c.bg_d, bg = c.bg_d },
  TelescopeResultsNormal = { bg = c.bg_d },
  TelescopeResultsTitle = { fg = c.bg, bg = c.blue },
}

for key, val in pairs(colors) do
  vim.api.nvim_set_hl(0, key, val)
end

--  {
--   bg0 = "#1f2329",
--   bg1 = "#282c34",
--   bg2 = "#30363f",
--   bg3 = "#323641",
--   bg_alt = "#1f2329",
--   bg_blue = "#61afef",
--   bg_d = "#181b20",
--   bg_yellow = "#e8c88c",
--   black = "#0e1013",
--   blue = "#4fa6ed",
--   cyan = "#48b0bd",
--   dark_cyan = "#266269",
--   dark_purple = "#7e3992",
--   dark_red = "#8b3434",
--   dark_yellow = "#835d1a",
--   diff_add = "#272e23",
--   diff_change = "#172a3a",
--   diff_delete = "#2d2223",
--   diff_text = "#274964",
--   fg = "#a0a8b7",
--   green = "#8ebd6b",
--   grey = "#535965",
--   light_grey = "#7a818e",
--   none = "none",
--   orange = "#cc9057",
--   purple = "#bf68d9",
--   red = "#e55561",
--   yellow = "#e2b86b"
-- }
