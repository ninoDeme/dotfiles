local FolderPicker = {}

local uv = vim.uv or vim.loop

function FolderPicker.get_cmd(opts, filter)
  local cmd = "fdfind"
  local args = { "--type", "d", "--color", "never", "-E", ".git" }

  -- exclude
  for _, e in ipairs(opts.exclude or {}) do
    vim.list_extend(args, { "-E", e })
  end

  -- extensions
  local ft = opts.ft or {}
  ft = type(ft) == "string" and { ft } or ft
  ---@cast ft string[]
  for _, e in ipairs(ft) do
    table.insert(args, "-e")
    table.insert(args, e)
  end

  -- hidden
  if opts.hidden then
    table.insert(args, "--hidden")
  end

  -- ignored
  if opts.ignored then
    args[#args + 1] = "--no-ignore"
  end

  -- follow
  if opts.follow then
    args[#args + 1] = "-L"
  end

  -- extra args
  vim.list_extend(args, opts.args or {})

  -- file glob
  ---@type string?
  local pattern, pargs = Snacks.picker.util.parse(filter.search)
  vim.list_extend(args, pargs)

  pattern = pattern ~= "" and pattern or nil
  if pattern then
    table.insert(args, pattern)
  end

  -- dirs
  local dirs = opts.dirs or {}
  if opts.rtp then
    vim.list_extend(dirs, Snacks.picker.util.rtp())
  end
  if #dirs > 0 then
    dirs = vim.tbl_map(svim.fs.normalize, dirs) ---@type string[]
    if not pattern then
      args[#args + 1] = "."
    end
    vim.list_extend(args, dirs)
  end

  return cmd, args
end

function FolderPicker.files(opts, ctx)
  local cwd = not (opts.rtp or (opts.dirs and #opts.dirs > 0))
      and svim.fs.normalize(uv.cwd() or ".")
      or nil
  local cmd, args = FolderPicker.get_cmd(opts, ctx.filter)
  if not cmd then
    return function() end
  end
  if opts.debug.files then
    Snacks.notify(cmd .. " " .. table.concat(args or {}, " "))
  end
  return require("snacks.picker.source.proc").proc(
    ctx:opts({
      cmd = cmd,
      args = args,
      notify = not opts.live,
      transform = function(item)
        item.cwd = cwd
        item.file = item.text
      end,
    }),
    ctx
  )
end

return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    explorer = {
      enabled = true,
      replace_netrw = false, -- Replace netrw with the snacks explorer
    },
    picker = {
      enabled = true,
      sources = {
        projects = {
          dev = { "~/Projects" },
          patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn" },
          confirm = "jump"
        },
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
        },
        files = {
          hidden = true,
          ignored = true,
          follow = true,
        },
        grep = {
          hidden = true,
          ignored = true,
          follow = true,
        },
        folder = {
          finder = FolderPicker.files,
          format = "file",
          preview = "file",
          show_empty = true,
          hidden = true,
          ignored = true,
        }
      }
    },
    notifier = {
      width = {
        min = 45,
        max = 0.4
      },
    }
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end,              desc = "Smart Find Files" },
    { "<leader>,",       function() Snacks.picker.buffers() end,            desc = "Buffers" },
    { "<leader>s:",      function() Snacks.picker.command_history() end,    desc = "Command History" },
    { "<leader>sn",      function() Snacks.picker.notifications() end,      desc = "Notification History" },
    { "<leader>se",      function() Snacks.explorer() end,                  desc = "File Explorer" },
    { "<leader>.",       function() Snacks.explorer() end,                  desc = "File Explorer" },
    -- find
    { "<leader>ss",      function() Snacks.picker.grep() end,               desc = "Grep" },
    { "<leader>sb",      function() Snacks.picker.buffers() end,            desc = "Buffers" },
    -- { "<leader>Sc",      function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>sf",      function() Snacks.picker.files() end,              desc = "Find Files" },
    { "<leader>sF",      function() Snacks.picker.folder() end,              desc = "Find Folders" },
    { "<leader>sg",      function() Snacks.picker.git_files() end,          desc = "Find Git Files" },
    { "<leader>sp",      function() Snacks.picker.projects() end,           desc = "Projects" },
    { "<leader>sr",      function() Snacks.picker.recent() end,             desc = "Recent" },
    -- git
    { "<leader>gb",      function() Snacks.picker.git_branches({ all = true }) end,       desc = "Git Branches" },
    { "<leader>gB",      function() Snacks.picker.git_branches() end,       desc = "Git Branches (local only)" },
    { "<leader>gl",      function() Snacks.picker.git_log() end,            desc = "Git Log" },
    { "<leader>gL",      function() Snacks.picker.git_log_line() end,       desc = "Git Log Line" },
    -- { "<leader>Gs",       function() Snacks.picker.git_status() end,         desc = "Git Status" },
    -- { "<leader>GS",       function() Snacks.picker.git_stash() end,          desc = "Git Stash" },
    -- { "<leader>Gd",       function() Snacks.picker.git_diff() end,           desc = "Git Diff (Hunks)" },
    { "<leader>gf",      function() Snacks.picker.git_log_file() end,       desc = "Git Log File" },
    -- Grep
    { "<leader>sb",      function() Snacks.picker.lines() end,              desc = "Buffer Lines" },
    { "<leader>sB",      function() Snacks.picker.grep_buffers() end,       desc = "Grep Open Buffers" },
    { "<leader>sw",      function() Snacks.picker.grep_word() end,          desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"',      function() Snacks.picker.registers() end,          desc = "Registers" },
    { '<leader>s/',      function() Snacks.picker.search_history() end,     desc = "Search History" },
    { "<leader>sa",      function() Snacks.picker.autocmds() end,           desc = "Autocmds" },
    { "<leader>sb",      function() Snacks.picker.lines() end,              desc = "Buffer Lines" },
    -- { "<leader>sc",      function() Snacks.picker.command_history() end,    desc = "Command History" },
    { "<leader>sC",      function() Snacks.picker.commands() end,           desc = "Commands" },
    { "<leader>sd",      function() Snacks.picker.diagnostics() end,        desc = "Diagnostics" },
    { "<leader>sD",      function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh",      function() Snacks.picker.help() end,               desc = "Help Pages" },
    { "<leader>sH",      function() Snacks.picker.highlights() end,         desc = "Highlights" },
    { "<leader>si",      function() Snacks.picker.icons() end,              desc = "Icons" },
    { "<leader>sj",      function() Snacks.picker.jumps() end,              desc = "Jumps" },
    { "<leader>sk",      function() Snacks.picker.keymaps() end,            desc = "Keymaps" },
    { "<leader>sl",      function() Snacks.picker.loclist() end,            desc = "Location List" },
    { "<leader>sm",      function() Snacks.picker.marks() end,              desc = "Marks" },
    { "<leader>sM",      function() Snacks.picker.man() end,                desc = "Man Pages" },
    { "<leader>sP",      function() Snacks.picker.lazy() end,               desc = "Search for Plugin Spec" },
    { "<leader>sq",      function() Snacks.picker.qflist() end,             desc = "Quickfix List" },
    { "<leader>sR",      function() Snacks.picker.resume() end,             desc = "Resume" },
    { "<leader>su",      function() Snacks.picker.undo() end,               desc = "Undo History" },
    { "<leader>uc",      function() Snacks.picker.colorschemes() end,       desc = "Colorschemes" },
    -- LSP
    -- { "gd",              function() Snacks.picker.lsp_definitions() end,                         desc = "Goto Definition" },
    -- { "gD",              function() Snacks.picker.lsp_declarations() end,                        desc = "Goto Declaration" },
    -- { "gr",              function() Snacks.picker.lsp_references() end,                          nowait = true,                       desc = "References" },
    -- { "gI",              function() Snacks.picker.lsp_implementations() end,                     desc = "Goto Implementation" },
    -- { "gy",              function() Snacks.picker.lsp_type_definitions() end,                    desc = "Goto T[y]pe Definition" },
    -- { "gai",             function() Snacks.picker.lsp_incoming_calls() end,                      desc = "C[a]lls Incoming" },
    -- { "gao",             function() Snacks.picker.lsp_outgoing_calls() end,                      desc = "C[a]lls Outgoing" },
    -- { "<leader>ss",      function() Snacks.picker.lsp_symbols() end,                             desc = "LSP Symbols" },
    -- { "<leader>sS",      function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "LSP Workspace Symbols" },
  },
}
