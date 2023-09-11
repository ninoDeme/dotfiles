local M = {}


local borders = {
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
  local b = borders[style]
  return {
    b[1],
    b[2],
    b[3],
    b[4],
    b[5],
    b[6],
    b[7],
    b[8],
  }
end

--- setup
---@param style HoverStyle Border Style
M.setup = function(style)
  M.style = style or 'normal'
  M.border = M.mk_border(style)

  vim.diagnostic.config({
    severity_sort = true,
    float = {
      border = M.border
    }
  })
end

M.set_highlights = function(colors)
  if M.style == 'normal' then
    return {
      FloatNormal = { bg = colors.bg },
      NormalFloat = { bg = colors.bg },
      FloatBorder = { bg = colors.bg, fg = colors.bg },
      BqfPreviewTitle = { bg = colors.bg, fg = colors.blue },
    }
  elseif M.style == 'dark' then
    return {
      FloatNormal = { bg = colors.bg_d },
      NormalFloat = { bg = colors.bg_d },
      FloatBorder = { bg = colors.bg_d, fg = colors.bg_d },
      BqfPreviewTitle = { bg = colors.bg_d, fg = colors.blue },
    }
  else
    return {
      FloatNormal = { link = 'Normal' },
      NormalFloat = { link = 'Normal' },
      FloatBorder = { bg = colors.bg, fg = colors.blue },
      BqfPreviewTitle = { bg = colors.bg, fg = colors.blue },
    }
  end
end

return M
