local M = {}

M.setup = function()
  local highlights = {

    DapBreakpoint = { link = "Debug" },
    DapBreakpointCondition = { link = "Debug" },
    DapLogPoint = { link = "Debug" },
    DapStopped = { fg = "Green" },
    DapStoppedLine = { link = "Visual" },
    DapBreakpointRejected = { link = "Ignore" },

    BqfPreviewFloat = { link = "NormalFloat" },

    TreesitterContext = { link = "NormalFloat" },

    DiagnosticUnderlineError = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticError" }).fg },
    DiagnosticUnderlineWarn = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticWarn" }).fg },
    DiagnosticUnderlineInfo = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticInfo" }).fg },
    DiagnosticUnderlineHint = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticHint" }).fg },
    DiagnosticUnderlineOk = { undercurl = true, sp = vim.api.nvim_get_hl(0, { name = "DiagnosticOk" }).fg },

    OilSize = { link = "String" },
    OilMtime = { link = "Directory" },

    -- TabLine = { bg = colors.lightbg },
    -- TabLineSel = { bold = true, bg = colors.statusline_bg },
    -- TabLineModified = { fg = colors.yellow },
    -- TabLineTitle = { fg = colors.blue },

    -- TabLineBranch = { fg = colors.purple },

    WinBarNC = { link = "Normal" },
    WinBar = { link = "Normal" },
    WinBarPathRel = { link = "Title" },

    QuickFixLine = { fg = "none", underline = true, sp = "none" },

    -- Identifier = { link = "" }

    -- HeirLine = { bg = colors.statusline_bg },

    -- StatusLine = { link = "StatusLineNC" }
  }

  highlights = vim.tbl_extend("force", highlights, require("hover").set_highlights(M.colors))

  M.apply_highlights(highlights)
end

M.apply_highlights = function(highlights)
  for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
  end
end

return M
