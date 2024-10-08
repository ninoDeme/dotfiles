local M = {}

M = {
  ui = {
    ------------------------------- base46 -------------------------------------
    -- hl = highlights
    --
    cmp = {
      enabled = false,
      icons = true,
      lspkind_text = true,
      style = "flat_light", -- default/flat_light/flat_dark/atom/atom_colored
    },
    --
    telescope = { style = "bordered" }, -- borderless / bordered

    ------------------------------- nvchad_ui modules -----------------------------
    statusline = {
      enabled = false,
      theme = "default", -- default/vscode/vscode_colored/minimal
      -- default/round/block/arrow separators work only for default statusline theme
      -- round and block will work for minimal theme only
      separator_style = "default",
      order = nil,
      modules = nil,
    },

    -- lazyload it when there are 1+ buffers
    tabufline = {
      enabled = true,
      lazyload = false,
      order = { "buffers", "tabs", "btns" },
      modules = nil,
    },

    nvdash = {
      enabled = false,
      -- load_on_startup = false,
      --
      -- header = {
      --   "           ▄ ▄                   ",
      --   "       ▄   ▄▄▄     ▄ ▄▄▄ ▄ ▄     ",
      --   "       █ ▄ █▄█ ▄▄▄ █ █▄█ █ █     ",
      --   "    ▄▄ █▄█▄▄▄█ █▄█▄█▄▄█▄▄█ █     ",
      --   "  ▄ █▄▄█ ▄ ▄▄ ▄█ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄  ",
      --   "  █▄▄▄▄ ▄▄▄ █ ▄ ▄▄▄ ▄ ▄▄▄ ▄ ▄ █ ▄",
      --   "▄ █ █▄█ █▄█ █ █ █▄█ █ █▄█ ▄▄▄ █ █",
      --   "█▄█ ▄ █▄▄█▄▄█ █ ▄▄█ █ ▄ █ █▄█▄█ █",
      --   "    █▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄█ █▄█▄▄▄█    ",
      -- },
      --
      -- buttons = {
      --   { "  Find File", "Spc f f", "Telescope find_files" },
      --   { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      --   { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      --   { "  Bookmarks", "Spc m a", "Telescope marks" },
      --   { "  Themes", "Spc t h", "Telescope themes" },
      --   { "  Mappings", "Spc c h", "NvCheatsheet" },
      -- },
    },

    term = {
      hl = "Normal:term,WinSeparator:WinSeparator",
      sizes = { sp = 0.3, vsp = 0.2 },
      float = {
        relative = "editor",
        row = 0.3,
        col = 0.25,
        width = 0.5,
        height = 0.4,
        border = "single",
      },
    },
  },

  lsp = { signature = false, renamer = false },

  mason = {},

  cheatsheet = {
    theme = "grid",                                                     -- simple/grid
    excluded_groups = { "terminal (t)", "autopairs", "Nvim", "Opens" }, -- can add group name or with mode
  },

  base46 = {
    integrations = {
      "blankline",
      -- "cmp",
      "defaults",
      "devicons",
      "git",
      "lsp",
      "mason",
      -- "nvcheatsheet",
      -- "nvdash",
      -- "nvimtree",
      "statusline",
      "syntax",
      "treesitter",
      -- "tbline",
      "telescope",
      "whichkey",
    },
    theme = "everblush", -- default theme
    hl_add = {},
    hl_override = {},
    changed_themes = {},
    theme_toggle = { "onedark", "one_light" },
    transparency = false,
  },
}


return M
