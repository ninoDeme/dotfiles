local M = {}

local alt_borders = {
  normal = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
  },
  dark = {
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
    " ",
  },
}

local borders = {
  normal = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  },
  dark = {
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
  },
  curved = {
    "╭",
    "─",
    "╮",
    "│",
    "╯",
    "─",
    "╰",
    "│",
  },
  light = {
    "┌",
    "─",
    "┐",
    "│",
    "┘",
    "─",
    "└",
    "│",
  },
  heavy = {
    "┏",
    "━",
    "┓",
    "┃",
    "┛",
    "━",
    "┗",
    "┃",
  },
}

---@alias HoverStyle 'normal'|'dark'|'curved'|'light'|'heavy' Border Style

---@type HoverStyle
M.style = 'normal'

--- Get Border Style
---@param style? HoverStyle Border Style
---@return table
M.mk_border = function(style)
  style = style or M.style
  return borders[style]
end

--- Get Border Style
---@param style? HoverStyle Border Style
---@return table
M.mk_alt_border = function(style)
  style = style or M.style
  return alt_borders[style] or borders[style]
end

--- setup
---@param style HoverStyle Border Style
M.setup = function(style)
  M.style = style or 'normal'
  M.border = M.mk_border(style)
  M.alt_border = M.mk_alt_border(style)
end

M.set_highlights = function(colors)
  if M.style == 'normal' then
    return {
      FloatNormal = { bg = colors.bg1 },
      -- PMenu = { bg = colors.bg1 },
      NormalFloat = { bg = colors.bg1 },
      FloatTitle = { bg = colors.bg1, fg = colors.blue },
      FloatBorder = { bg = colors.bg1, fg = colors.bg1 },
      BqfPreviewTitle = { bg = colors.bg1, fg = colors.blue },
    }
  elseif M.style == 'dark' then
    return {
      FloatNormal = { bg = colors.bg_d },
      -- PMenu = { bg = colors.bg_d },
      NormalFloat = { bg = colors.bg_d },
      FloatTitle = { bg = colors.bg_d, fg = colors.blue },
      FloatBorder = { bg = colors.bg_d, fg = colors.bg_d },
      BqfPreviewTitle = { bg = colors.bg_d, fg = colors.blue },
    }
  else
    return {
      FloatNormal = { link = 'Normal' },
      -- PMenu = { link = 'Normal' },
      NormalFloat = { link = 'Normal' },
      FloatTitle = { bg = colors.bg, fg = colors.blue },
      FloatBorder = { bg = colors.bg, fg = colors.fg },
      BqfPreviewTitle = { bg = colors.bg, fg = colors.blue },
    }
  end
end

return M
