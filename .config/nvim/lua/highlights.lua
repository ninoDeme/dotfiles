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

    WinBarNC = { link = "Normal" },
    WinBar = { link = "Normal" },
    WinBarPathRel = { link = "Title" },

    QuickFixLine = { fg = "none", underline = true, sp = "none" },

    OverseerTaskBorder = { link = "WinSeparator" },
  }

  M.apply_highlights(highlights)
end

M.apply_highlights = function(highlights)
  for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
  end
end

return M
