local M = {}


--- @param name string
local function get_hl(name)
  return vim.api.nvim_get_hl(0, {
    name = name,
    link = false
  })
end

M.apply_hl = function()
  local highlights = {

    DapBreakpoint = { link = "Debug" },
    DapBreakpointCondition = { link = "Debug" },
    DapLogPoint = { link = "Debug" },
    DapStopped = { fg = "Green" },
    DapStoppedLine = { link = "Visual" },
    DapBreakpointRejected = { link = "Ignore" },

    BqfPreviewFloat = { link = "NormalFloat" },

    TreesitterContext = { link = "NormalFloat" },

    DiagnosticUnderlineError = { undercurl = true, sp = get_hl("DiagnosticError").fg },
    DiagnosticUnderlineWarn = { undercurl = true, sp = get_hl("DiagnosticWarn").fg },
    DiagnosticUnderlineInfo = { undercurl = true, sp = get_hl("DiagnosticInfo").fg },
    DiagnosticUnderlineHint = { undercurl = true, sp = get_hl("DiagnosticHint").fg },
    DiagnosticUnderlineOk = { undercurl = true, sp = get_hl("DiagnosticOk").fg },

    OilSize = { link = "String" },
    OilMtime = { link = "Directory" },

    WinBarNC = { link = "Normal" },
    WinBar = { link = "Normal" },
    WinBarPathRel = { link = "Title" },

    QuickFixLine = { fg = "none", underline = true, sp = "none" },

    OverseerTaskBorder = { link = "WinSeparator" },

    SnacksPickerDir = { link = "Directory" }
  }

  if vim.g.colors_name == 'badwolf' then
    highlights = vim.tbl_extend('force', highlights, {
      DiffDelete = { link = "Removed" }
    })
  end

  if vim.g.colors_name == 'zaibatsu' then
    highlights = vim.tbl_extend('force', highlights, {
      NormalFloat = { link = "Normal" },
      MatchParen = { underline = true }
    })
  end

  if vim.g.colors_name == 'retrobox' then
    highlights = vim.tbl_extend('force', highlights, {
      NormalFloat = { link = "Normal" },
    })
  end

  M.apply_highlights(highlights)
end

M.apply_highlights = function(highlights)
  for key, val in pairs(highlights) do
    vim.api.nvim_set_hl(0, key, val)
  end
end

M.apply_term = function(term)
  for i, color in ipairs(term) do
    vim.g['terminal_color_' .. (i - 1)] = color.dark
    vim.g['terminal_color_' .. (i - 1 + 8)] = color.bright
  end
end

M.color_schemes = {}

M.setup = function(color_schemes)
  M.color_schemes = color_schemes
  vim.o.background = 'dark'

  math.randomseed(os.time())

  if vim.env.TERMINAL_THEME ~= nil and vim.env.TERMINAL_THEME ~= "" then
    vim.cmd.colorscheme(vim.env.TERMINAL_THEME)
  else
    M.randomize()
  end
end

M.randomize = function()
  --- @type string | table
  local color = M.color_schemes

  while type(color) ~= 'string' do
    color = color[math.random(#color)]
  end

  vim.cmd.colorscheme(color)
end

vim.api.nvim_create_user_command('Randomize', function()
  M.randomize()
  return vim.cmd.colorscheme()
end, {})

vim.keymap.set("n", "<leader>tt", function()
  M.randomize()
  vim.cmd.colorscheme();
end)

local function rgbToHex(val)
  if type(val) == 'number' then
    return string.format("#%06x", val)
  else
    return val
  end
end


local Path = require('plenary.path')

M.extract_bg = function(colors, prefix)
  if prefix == nil then
    prefix = vim.fn.expand("~/dotfiles/.config/alacritty/themes/")
  end
  if colors == nil then
    dd(colors)
    colors = M.color_schemes
  end
  local path = Path.new(prefix)
  if path:exists() then
    path:rm({ recursive = true })
  end
  if not path:exists() then
    path:mkdir({ parents = true })
    dd(path.filename)
  end

  for k, scheme in pairs(colors) do
    if k == "name" then
    elseif type(scheme) == "table" then
      M.extract_bg(scheme, prefix .. scheme.name .. '/')
    else
      vim.cmd.colorscheme(scheme)
      local cterm = {
        "black",
        "red",
        "green",
        "yellow",
        "blue",
        "magenta",
        "cyan",
        "white",
      }
      local bright = {}
      local dark = {}
      for i, _ in ipairs(cterm) do
        bright[i] = vim.g['terminal_color_' .. (i - 1)]
        dark[i] = vim.g['terminal_color_' .. (i - 1 + 8)]
      end
      local res = string.format([[
# Colors (%s)

# Default colors
[colors.primary]
background = '%s'
foreground = '%s'

# Normal colors
[colors.normal]
black   = '%s'
red     = '%s'
green   = '%s'
yellow  = '%s'
blue    = '%s'
magenta = '%s'
cyan    = '%s'
white   = '%s'

# Bright colors
[colors.bright]
black   = '%s'
red     = '%s'
green   = '%s'
yellow  = '%s'
blue    = '%s'
magenta = '%s'
cyan    = '%s'
white   = '%s'
]],
        scheme,
        rgbToHex(vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg),
        rgbToHex(vim.api.nvim_get_hl(0, { name = "Normal", link = false }).fg),
        rgbToHex(dark[1]),
        rgbToHex(dark[2]),
        rgbToHex(dark[3]),
        rgbToHex(dark[4]),
        rgbToHex(dark[5]),
        rgbToHex(dark[6]),
        rgbToHex(dark[7]),
        rgbToHex(dark[8]),
        rgbToHex(bright[1]),
        rgbToHex(bright[2]),
        rgbToHex(bright[3]),
        rgbToHex(bright[4]),
        rgbToHex(bright[5]),
        rgbToHex(bright[6]),
        rgbToHex(bright[7]),
        rgbToHex(bright[8])
      )
      local uv = vim.uv
      local fd, _, err_name = uv.fs_open(
        string.format("%s%s.toml", prefix, scheme),
        "w",
        tonumber('644', 8)
      )
      if err_name ~= nil then
        dd(err_name)
      end
      assert(fd)
      assert(uv.fs_write(fd, res, 0))
      assert(uv.fs_close(fd))
    end
  end
end

_G.ExtractBg = M.extract_bg

local res = {}
Overwr = function()
  local old = vim.api.nvim_set_hl
  if #res then
    local cterm = {
      "black",
      "red",
      "green",
      "yellow",
      "blue",
      "magenta",
      "cyan",
      "white",
    }
    local ansi_term = {}
    for i, _ in ipairs(cterm) do
      ansi_term[i] = {
        dark = vim.g['terminal_color_' .. (i - 1)],
        bright = vim.g['terminal_color_' .. (i - 1 + 8)]
      }
    end
    local uv = vim.uv
    local fd, _, err_name = uv.fs_open(
      vim.fn.expand("~/theme.lua"),
      "w",
      tonumber('644', 8)
    )
    if err_name ~= nil then
      dd(err_name)
    end
    assert(fd)
    assert(uv.fs_write(fd, vim.inspect({ hl = res, term = ansi_term }), 0))
    assert(uv.fs_close(fd))
  end
  res = {}
  vim.api.nvim_set_hl = function(ns_id, name, val)
    res[name] = val
    return old(ns_id, name, val)
  end
end

GetTerm = function()
end

return M
