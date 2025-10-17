vim.o.background = 'dark'
vim.cmd.hi('clear')
vim.g.colors_name = 'gruber'

vim.opt.termguicolors = true

local fg0 = "#e4e4ef"
local fg1 = "#f4f4ff"
local fg2 = "#f5f5f5"
local fg3 = "#a89984"
local fg4 = "#686868"
local bg0 = "#181818"
local bg1 = "#282828"
local bg2 = "#453d41"
local bg3 = "#484848"
local bg4 = "#52494e"
local bg5 = "#404040"
local bg6 = "#232323"
local bg7 = "#3f3f3f"
local bg8 = "#2c2c2c"
local red0 = "#f43841"
local red1 = "#ff4f58"
local red2 = "#2B0A0B"
local red3 = "#fb4934"
local green0 = "#73c936"
local green1 = "#b8bb26"
local yellow0 = "#ffdd33"
local yellow1 = "#655814"
local blue0 = "#5292c8"
local orange0 = "#d65d0e"
local orange1 = "#fe8019"
local brown0 = "#cc8c3c"
local quartz = "#95a99f"
local niagara0 = "#96a6c8"
local niagara1 = "#303540"
local wisteria = "#9e95c7"
local aqua1 = "#8ec07c"

-- local c = {
--   fg0 = { hex = "#e4e4ef", x256 = 255, h256 = "#eeeeee" },
--   fg1 = { hex = "#f4f4ff", x256 = 15, h256 = "#ffffff" },
--   fg2 = { hex = "#f5f5f5", x256 = 255, h256 = "#eeeeee" },
--   fg3 = { hex = "#a89984", x256 = 144, h256 = "#afaf87" },
--   fg4 = { hex = "#686868", x256 = 242, h256 = "#6c6c6c" },
--   bg0 = { hex = "#181818", x256 = 234, h256 = "#1c1c1c" },
--   bg1 = { hex = "#282828", x256 = 235, h256 = "#262626" },
--   bg2 = { hex = "#453d41", x256 = 238, h256 = "#444444" },
--   bg3 = { hex = "#484848", x256 = 238, h256 = "#444444" },
--   bg4 = { hex = "#52494e", x256 = 239, h256 = "#4e4e4e" },
--   bg5 = { hex = "#404040", x256 = 238, h256 = "#444444" },
--   bg6 = { hex = "#232323", x256 = 235, h256 = "#262626" },
--   bg7 = { hex = "#3f3f3f", x256 = 237, h256 = "#3a3a3a" },
--   bg8 = { hex = "#2c2c2c", x256 = 236, h256 = "#303030" },
--   red0 = { hex = "#f43841", x256 = 09, h256 = "#ff0000" },
--   red1 = { hex = "#ff4f58", x256 = 203, h256 = "#ff5f5f" },
--   red2 = { hex = "#2B0A0B", x256 = 52, h256 = "#5f0000" },
--   red3 = { hex = "#fb4934", x256 = 203, h256 = "#ff5f5f" },
--   green0 = { hex = "#73c936", x256 = 112, h256 = "#87d700" },
--   green1 = { hex = "#b8bb26", x256 = 142, h256 = "#afaf00" },
--   yellow0 = { hex = "#ffdd33", x256 = 220, h256 = "#ffd700" },
--   yellow1 = { hex = "#655814", x256 = 58, h256 = "#5f5f00" },
--   blue0 = { hex = "#5292c8", x256 = 74, h256 = "#5fafd7" },
--   orange0 = { hex = "#d65d0e", x256 = 166, h256 = "#d75f00" },
--   orange1 = { hex = "#fe8019", x256 = 208, h256 = "#ff8700" },
--   brown0 = { hex = "#cc8c3c", x256 = 172, h256 = "#d78700" },
--   quartz = { hex = "#95a99f", x256 = 247, h256 = "#9e9e9e" },
--   niagara0 = { hex = "#96a6c8", x256 = 146, h256 = "#afafff" },
--   niagara1 = { hex = "#303540", x256 = 237, h256 = "#3a3a3a" },
--   wisteria = { hex = "#9e95c7", x256 = 146, h256 = "#d7afff" },
--   aqua1 = { hex = "#8ec07c", x256 = 108, h256 = "#87af87" },
-- }

-- local ansi_term = {
--   { dark = bg0,      bright = bg2 },      -- black
--   { dark = red1,     bright = red0 },     -- red
--   { dark = green0,   bright = aqua1 },    -- green
--   { dark = yellow0,  bright = yellow0 },  -- yellow
--   { dark = niagara0, bright = blue0 },    -- blue
--   { dark = niagara1, bright = wisteria }, -- magenta
--   { dark = quartz,   bright = quartz },   -- cyan
--   { dark = fg0,      bright = fg1 },      -- white
-- }

local ansi_term = {
  { dark = "#000000",bright = bg2 },      -- black
  { dark = red1,     bright = red0 },     -- red
  { dark = green0,   bright = aqua1 },    -- green
  { dark = yellow0,  bright = yellow0 },  -- yellow
  { dark = blue0,    bright = blue0 },    -- blue
  { dark = wisteria, bright = wisteria }, -- magenta
  { dark = quartz,   bright = quartz },   -- cyan
  { dark = fg0,      bright = fg1 },      -- white
}

for i, color in ipairs(ansi_term) do
  vim.g['terminal_color_' .. (i - 1)] = color.dark
  vim.g['terminal_color_' .. (i - 1 + 8)] = color.bright
end

local theme = {
  Normal = { fg = fg0, bg = bg0 },
  NormalNC = { fg = fg0, bg = bg0 },
  -- NormalNC = { fg = fg0, bg = "#1a1a1a" },
  Boolean = { fg = wisteria },
  Character = { fg = green0, },
  ColorColumn = {},
  Comment = { fg = brown0, },
  Conceal = { fg = fg3 },
  Conditional = {},
  Constant = {},
  Cursor = { fg = niagara1, bg = fg0, },
  CursorColumn = {},
  -- CursorIM = {},
  CursorLine = { bg = bg6 },
  CursorLineNr = { fg = yellow0, },
  Debug = { fg = red0, },
  Define = { fg = yellow0, bold = true },
  Delimiter = {},

  Directory = { fg = niagara0, nil, },
  -- EndOfBuffer = {},
  Error = { fg = red0, },
  ErrorMsg = { fg = red0, },
  Exception = { link = "Keyword", },
  Float = { link = "Number" },
  NormalFloat = { bg = bg6, fg = fg1 },
  FloatBorder = { fg = fg1, bg = bg6 },
  FoldColumn = { fg = fg1 },
  Fold = { fg = fg1 },
  Function = { fg = niagara0, },
  Identifier = {},
  Ignore = { fg = fg2, },
  IncSearch = { bg = bg2 },
  Keyword = { fg = yellow0, bold = true },
  Include = { link = "Keyword" },
  Label = { link = "Keyword" },
  LineNr = { fg = fg3 },
  -- Macro = {},
  MatchParen = { bg = bg1 },
  ModeMsg = { fg = brown0, },
  MoreMsg = { fg = yellow0, },
  MsgArea = {},
  MsgSeparator = { bg = bg1 },
  NonText = { fg = brown0 },
  Number = { fg = wisteria },
  Operator = {},
  Pmenu = { fg = fg0, bg = bg6 },
  PmenuSbar = { bg = yellow0 },
  PmenuSel = { bg = bg5, bold = true },
  PmenuThumb = { bg = yellow1 },
  PreCondit = { fg = yellow0, bold = true },
  PreProc = { fg = yellow0, bold = true },
  Question = { fg = yellow0, },
  QuickFixLine = { fg = "none", underline = true, sp = "none" },
  Repeat = { link = "Keyword" },
  Search = { bg = bg2 },
  SignColumn = {},
  Special = { fg = yellow0 },
  SpecialChar = { fg = yellow0, bold = true },
  SpecialComment = { fg = yellow0, bold = true },
  SpecialKey = { fg = yellow0, bold = true },
  -- SpellBad = {},
  -- SpellCap = {},
  -- SpellLocal = {},
  -- SpellRare = {},
  StatusLine = { fg = fg0, bg = bg1 },
  StatusLineNC = { fg = fg0, bg = bg2 },
  StorageClass = { link = "Keyword" },
  String = { fg = green0 },
  Structure = { link = "Keyword" },
  Substitute = { bg = bg1 },
  TabLine = { bg = bg2 },
  TabLineFill = { bg = bg1 },
  TabLineSel = { bg = bg0 },
  TermCursor = {},
  TermCursorNC = { bg = fg1 },
  Title = { fg = quartz, bold = true, },
  Todo = { fg = quartz, },
  Type = { fg = quartz, },
  Typedef = { link = "Keyword" },
  Underlined = { underline = true },
  Variable = { fg = fg0 },
  Visual = { bg = bg8, },
  -- VisualNOS = {},
  WarningMsg = { fg = orange0, },
  -- Whitespace = { fg = bg2 },
  Whitespace = { fg = bg2 },
  WinSeparator = { fg = bg4 },
  WildMenu = { link = "PmenuSel" },
  lCursor = {},

  DiagnosticError = { fg = red3, },
  DiagnosticHint = { fg = blue0, },
  DiagnosticInfo = { fg = aqua1, },
  DiagnosticWarn = { fg = orange1, },
  DiagnosticUnnecessary = { fg = fg4, },

  DiffAdd = { fg = green0, },
  DiffChange = { fg = green1, },
  DiffDelete = { fg = red1, },
  DiffText = { fg = orange0, },

  Added = { fg = green0, },
  Changed = { fg = green1, },
  Removed = { fg = red1, },

  -- DapBreakpoint = { fg = red0 },
  -- DapBreakpointCondition = { fg  },
  -- DapLogPoint = {},
  -- DapStopped = {},
  -- DapBreakpointRejected = {},

  ["@constructor"] = { fg = quartz },
  ["@variable"] = { fg = fg0 },

  ["@tag.delimiter"] = { link = "Delimiter" },
  ["@tag.attribute"] = { link = "Variable" },
  Tag = { link = "Function" },

  TelescopeBorder = { fg = bg4 },
  TelescopeMultiSelection = { fg = aqua1 },

  -- Cmp
  -- CmpItemAbbrDeprecated = { fg = 'NONE', bg = 'NONE', strikethrough=true, },
  -- CmpItemAbbrMatch = { fg = c.blue, bg = 'NONE' },
  -- CmpItemAbbrMatchFuzzy = { fg = c.blue, bg = 'NONE' },
  CmpItemKindFunction = { fg = blue0, bg = 'NONE' },
  CmpItemKindMethod = { fg = blue0, bg = 'NONE' },
  CmpItemKindConstructor = { fg = aqua1, bg = 'NONE' },
  CmpItemKindClass = { fg = aqua1, bg = 'NONE' },
  CmpItemKindEnum = { fg = aqua1, bg = 'NONE' },
  CmpItemKindEvent = { fg = yellow0, bg = 'NONE' },
  CmpItemKindInterface = { fg = aqua1, bg = 'NONE' },
  CmpItemKindStruct = { fg = aqua1, bg = 'NONE' },
  CmpItemKindVariable = { fg = red1, bg = 'NONE' },
  CmpItemKindField = { fg = red1, bg = 'NONE' },
  CmpItemKindProperty = { fg = red1, bg = 'NONE' },
  CmpItemKindEnumMember = { fg = orange0, bg = 'NONE' },
  CmpItemKindConstant = { fg = orange0, bg = 'NONE' },
  CmpItemKindKeyword = { fg = yellow0, bg = 'NONE' },
  CmpItemKindModule = { fg = aqua1, bg = 'NONE' },
  CmpItemKindValue = { fg = fg0, bg = 'NONE' },
  CmpItemKindUnit = { fg = fg0, bg = 'NONE' },
  CmpItemKindText = { fg = fg0, bg = 'NONE' },
  CmpItemKindSnippet = { fg = blue0, bg = 'NONE' },
  CmpItemKindFile = { fg = fg0, bg = 'NONE' },
  CmpItemKindFolder = { fg = niagara0, bg = 'NONE' },
  CmpItemKindColor = { fg = green0, bg = 'NONE' },
  CmpItemKindReference = { fg = quartz, bg = 'NONE' },
  CmpItemKindOperator = { fg = fg0, bg = 'NONE' },
  CmpItemKindTypeParameter = { fg = quartz, bg = 'NONE' },
}

require('highlights').apply_highlights(theme)
