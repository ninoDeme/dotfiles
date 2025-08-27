vim.o.background = 'dark'
vim.cmd.hi('clear')

vim.opt.termguicolors = true
vim.g.colors_name = 'gruber'

local fg0 = "#e4e4ef"
local fg1 = "#f4f4ff"
local fg2 = "#f5f5f5"
local fg3 = "#a89984"
local fg4 = "#686868"
local bg0 = "#181818"
local bg1 = "#282828"
local bg2 = "#453d41"
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

local theme = {
  Normal = { fg = fg0, bg = bg0 },
  NormalNC = { link = "Normal" },
  Boolean = {},
  Character = { fg = green0, },
  ColorColumn = {},
  Comment = { fg = brown0, },
  Conceal = { fg = bg1, },
  Conditional = {},
  Constant = {},
  Cursor = { fg = niagara1, bg = fg0, },
  CursorColumn = {},
  -- CursorIM = {},
  CursorLine = {},
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
  MatchParen = {bg = bg1 },
  ModeMsg = { fg = brown0, },
  MoreMsg = { fg = yellow0, },
  MsgArea = {},
  MsgSeparator = {bg = bg1 },
  NonText = { fg = brown0 },
  Number = { fg = wisteria },
  Operator = {},
  Pmenu = { fg = fg0, bg = bg6 },
  PmenuSbar = {bg = yellow0 },
  PmenuSel = {bg = bg5, bold = true },
  PmenuThumb = {bg = yellow1 },
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
  Substitute = {bg = bg1 },
  TabLine = { bg = bg2 },
  TabLineFill = { bg = bg1 },
  TabLineSel = { bg = bg0 },
  TermCursor = {},
  TermCursorNC = {bg = fg1 },
  Title = { fg = quartz, bold = true, },
  Todo = { fg = quartz, },
  Type = { fg = quartz, },
  Typedef = { link = "Keyword" },
  Underlined = { underline = true },
  Variable = { link = "Normal" },
  Visual = { bg = bg8, },
  -- VisualNOS = {},
  WarningMsg = { fg = orange0, },
  Whitespace = {},
  WinSeparator = { fg = bg4 },
  WildMenu = { link = "PmenuSel" },
  lCursor = {},

  DiagnosticError = { fg = red3, },
  DiagnosticHint = { fg = blue0, },
  DiagnosticInfo = { fg = aqua1, },
  DiagnosticWarn = { fg = orange1, },
  DiagnosticUnnecessary = { fg = fg4, },

  DiffAdd = { fg = green0, },
  DiffChange = { fg = yellow0, },
  DiffDelete = { fg = red0, },
  DiffText = { fg = orange0, },

  Added = { fg = green0, },
  Changed = { fg = yellow0, },
  Removed = { fg = red0, },

  -- DapBreakpoint = { fg = red0 },
  -- DapBreakpointCondition = { fg  },
  -- DapLogPoint = {},
  -- DapStopped = {},
  -- DapBreakpointRejected = {},

  ["@constructor"] = { fg = quartz },
  ["@variable"] = { link = "Normal" },

  ["@tag.delimiter"] = { link = "Delimiter" },
  ["@tag.attribute"] = { link = "Variable" },
  Tag = { link = "Function" },

  TelescopeBorder = { fg = bg4 },

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
