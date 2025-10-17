local M = {}

M.setup = function(style, alt_style)
  M.style = style or 'none'
  M.border = style
  M.alt_border = alt_style or 'solid'
end

return M
