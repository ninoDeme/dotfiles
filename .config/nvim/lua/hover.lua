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
  return {}
end

return M
