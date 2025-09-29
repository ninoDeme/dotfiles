if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
  vim.g.neovide_floating_shadow = false
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.05)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.05)
  end)
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function ()
    require("highlights").setup()
  end
})


require("hover").setup("normal")
vim.cmd.colorscheme("gruber")

-- Vim settings {{{

local diagnostic_config = {
  text = {},
  texthl = {},
  linehl = {},
  numhl = {},
}

local signs = {
  [vim.diagnostic.severity.ERROR] = { " ", nil, "DiagnosticError" },
  [vim.diagnostic.severity.WARN] = { " ", nil, "DiagnosticWarn" },
  [vim.diagnostic.severity.HINT] = { " ", nil, "DiagnosticHint" },
  [vim.diagnostic.severity.INFO] = { " ", nil, "DiagnosticInfo" },
}

for key, val in ipairs(signs) do
  diagnostic_config["text"][key] = val[1]
  diagnostic_config["linehl"][key] = val[2]
  diagnostic_config["numhl"][key] = val[3]
end

vim.diagnostic.config({
  signs = diagnostic_config,
  float = {
    source = true,
    border = require("hover").border, --- @diagnostic disable-line
  },
  severity_sort = true,
})

-- use system clipboard
-- vim.api.nvim_set_option("clipboard","unnamedplus")

-- map leader to space
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.guifont = "Iosevka Nerd Font:h9"
vim.opt.linespace = 1
vim.opt.wildmenu = true

-- Set highlight on search
vim.opt.hlsearch = true

-- deal with case sensitivity on search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.confirm = true
vim.opt.visualbell = true

-- -- add manual folding
-- vim.opt.foldmethod     = 'marker'
--
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false
-- vim.opt.foldlevel = 40

vim.opt.cmdheight = 1
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.laststatus = 2

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.signcolumn = "yes"

vim.opt.cursorline = true

vim.opt.scrolloff = 3

vim.opt.wrap = false
-- vim.opt.timeout = false
-- vim.opt.timeoutlen = 300

vim.opt.backupcopy = "yes"

vim.opt.linebreak = true
-- save undo history
vim.opt.undofile = true

vim.opt.inccommand = "split"
vim.opt.incsearch = true

vim.opt.completeopt = "menu,menuone,noselect,noinsert"

-- fix vim screen geometry on alacritty -e nvim
if os.getenv("TERM") == "alacritty" then
  vim.api.nvim_create_autocmd({ "VimEnter" }, {
    callback = function()
      local pid, WINCH = vim.fn.getpid(), vim.uv.constants.SIGWINCH
      vim.defer_fn(function()
        vim.uv.kill(pid, WINCH)
      end, 10)
    end,
  })
end

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ timeout = 200 })
  end
})

vim.opt.listchars = { tab = "→ ",trail = "·",eol = "¬",extends = "…",precedes = "…", space = "·" }

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>Y", '"+y$')
vim.keymap.set({ "n", "v" }, "<Leader>P", '"+p$')

vim.keymap.set({ "n" }, "<ESC>", "<CMD>nohlsearch<CR><ESC>", { silent = true, noremap = true })

vim.keymap.set({ "v" }, "g/", ":s///g<Left><left>", { silent = false, noremap = true })
vim.keymap.set({ "n" }, "g/", ':%s///g<Left><left>', { silent = false, noremap = true })

vim.keymap.set({ "t" }, "<C-\\><C-R>", "'<C-\\><C-N>\"'.nr2char(getchar()).'pi'", { expr = true, noremap = true })

vim.api.nvim_create_autocmd('CmdwinEnter', {
  pattern = '[:>]',
  desc = 'If the treesitter vim parser is installed, set the syntax again to get highlighting in the command window',
  group = vim.api.nvim_create_augroup('cmdwin_syntax', {}),
  callback = function()
    local is_loadable, _ = pcall(vim.treesitter.language.add, 'vim')
    if is_loadable then
      vim.cmd('set syntax=vim')
    end
  end
})

-- vim.kemap.set({ "i", "c" }, "<C-b>", "<Left>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-f>", "<Right>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-a>", "<Home>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-e>", "<End>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-d>", "<Del>", { silent = true, noremap = true })
-- vim.kemap.set({ "i", "c" }, "<C-h>", "<BS>", { silent = true, noremap = true })
-- vim.kemap.set({ "i" }, "<C-k>", "<C-r>=<SID>kill_line()<CR>", { silent = true, noremap = true })
-- vim.kemap.set({ "c" }, "<C-k>", "<C-f>D<C-c><C-c>:<Up>", { silent = true, noremap = true })

if vim.fn.has('mouse') then
  vim.opt.mouse = 'a'
end

-- }}}

vim.cmd([[
filetype plugin indent on

augroup Term
  autocmd!
  autocmd TermClose * ++nested stopinsert | au Term TermEnter <buffer> stopinsert
augroup end

]])

if vim.fn.executable('rg') then
  vim.opt.grepprg = 'rg --vimgrep'
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  dev = {
    path = "~/Projects",
    fallback = true,
  },
  defaults = {
    lazy = true,
  },
})

BASHCOMP_SRC = '/etc/bash_completion'
BASHCOMP_FUNCS = {}
LAST_CMD = nil

--- Check if a string starts with another string.
-- @DOC_text_gears_string_startswith_EXAMPLE@
-- @tparam string str String to search
-- @treturn boolean `true` if string starts with specified string
-- @tparam string sub String to check for.
-- @staticfct gears.string.startswith
local function startswith(str, sub)
  return str and (string.sub(str, 1, string.len(sub)) == sub) or false
end

local function bash_escape(str)
  str = str:gsub(" ", "\\ ")
  str = str:gsub("%[", "\\[")
  str = str:gsub("%]", "\\]")
  str = str:gsub("%(", "\\(")
  str = str:gsub("%)", "\\)")
  return str
end

--- Use shell completion system to complete commands and filenames.
-- @param string command The command line.
-- @tparam number cur_pos The cursor position.
-- @tparam number ncomp The element number to complete.
-- @tparam[opt=based on SHELL] string shell The shell to use for completion.
--   Supports "bash" and "zsh".
-- @treturn string The new command.
-- @treturn number The new cursor position.
-- @treturn table The table with all matches.
function SHELL_COMPLETION(command, cur_pos, shell)
  local wstart = 1
  local wend = 1
  local words = {}
  local cword_index = 0
  local i = 1
  local comptype = "file"

  local oil = require("oil")
  local cwd = oil.get_current_dir()

  local old_command = command
  local _, end_cmd_name = string.find(command, 'R!?%s+')
  command = string.sub(command, (end_cmd_name or 0) + 1)
  cur_pos = cur_pos - (#old_command - #command)

  while wend <= #command do
    wend = command:find(" ", wstart)
    if not wend then wend = #command + 1 end
    table.insert(words, command:sub(wstart, wend - 1))
    if cur_pos >= wstart and cur_pos <= wend + 1 then
      cword_index = i
    end
    wstart = wend + 1
    i = i + 1
  end

  if cword_index == 1 then
    comptype = "command"
  end

  local shell_cmd
  if not shell then
    local env_shell = os.getenv('SHELL')
    if not env_shell then
      shell = 'bash'
    elseif env_shell:match('zsh$') then
      shell = 'zsh'
    else
      shell = 'bash'
    end
  end
  if shell == 'zsh' then
    if comptype == "file" then
      -- NOTE: ${~:-"..."} turns on GLOB_SUBST, useful for expansion of
      -- "~/" ($HOME).  ${:-"foo"} is the string "foo" as var.
      shell_cmd = "/usr/bin/env zsh -c 'local -a res; res=( ${~:-"
          .. string.format('%q', words[cword_index]) .. "}*(N) ); "
          .. "print -ln -- ${res[@]}'"
    else
      -- Check commands, aliases, builtins, functions and reswords.
      -- Adds executables and non-empty dirs from $PWD (pwd_exe).
      shell_cmd = "/usr/bin/env zsh -c 'local -a res pwd_exe; " ..
          "pwd_exe=(*(N*:t) *(NF:t)); " ..
          "res=( " ..
          "\"${(k)commands[@]}\" \"${(k)aliases[@]}\" \"${(k)builtins[@]}\" \"${(k)functions[@]}\" " ..
          "\"${(k)reswords[@]}\" " ..
          "./${^${pwd_exe}} " ..
          "); " ..
          "print -ln -- ${(M)res[@]:#" .. string.format('%q', words[cword_index]) .. "*}'"
    end
  else
    if BASHCOMP_FUNCS[words[1]] then
      -- fairly complex command with inline bash script to get the possible completions
      shell_cmd = "/usr/bin/env bash -c 'source " .. BASHCOMP_SRC .. "; " ..
          (cwd ~= nil and "cd \"" .. vim.fn.fnamemodify(cwd, ":p") .. "\";" or "") ..
          "__print_completions() { for ((i=0;i<${#COMPREPLY[*]};i++)); do echo ${COMPREPLY[i]}; done }; " ..
          "COMP_WORDS=(" .. command .. "); COMP_LINE=\"" .. command .. "\"; " ..
          "COMP_COUNT=" .. cur_pos .. "; COMP_POINT=" .. cur_pos .. "; COMP_CWORD=" .. cword_index - 1 .. "; " ..
          BASHCOMP_FUNCS[words[1]] .. "; __print_completions'"
    else
      shell_cmd = "/usr/bin/env bash -c 'compgen -A " .. comptype .. " "
          .. string.format('%q', words[cword_index] or '') .. "'"
    end
  end
  local c, err = io.popen(shell_cmd .. " | sort -u")
  local output = {}
  if c then
    while true do
      local line = c:read("*line")
      if not line then break end
      if startswith(line, "./") and vim.fn.isdirectory(line) then
        line = line .. "/"
      end
      table.insert(output, bash_escape(line))
    end

    c:close()
  else
    vim.notify(err or "", vim.log.levels.ERROR)
  end

  return table.concat(output, '\n')
end

function BASHCOMP_LOAD(src)
  if src then BASHCOMP_SRC = src end
  local c, err = io.popen("/usr/bin/env bash -c 'source " .. BASHCOMP_SRC .. "; complete -p'")
  if c then
    while true do
      local line = c:read("*line")
      if not line then break end
      -- if a bash function is used for completion, register it
      if line:match(".* -F .*") then
        BASHCOMP_FUNCS[line:gsub(".* (%S+)$", "%1")] = line:gsub(".*-F +(%S+) .*$", "%1")
      end
    end
    c:close()
  else
    vim.notify(err or "", vim.log.levels.ERROR)
  end
end

local run_cmd = function(opts)
  local cmd = opts.args
  if cmd ~= nil and string.match(cmd, "%S") then
    local bang = opts.bang
    local flags = {}
    if bang then
      table.insert(flags, '-mode=terminal')
    end
    local flags_str = ""
    for _, value in ipairs(flags) do
      flags_str = flags_str .. " " .. value
    end
    cmd = string.format(' %s %s', flags_str, cmd)
  else
    if LAST_CMD ~= nil then
      cmd = LAST_CMD
    else
      error("Empty")
    end
  end
  LAST_CMD = cmd
  vim.cmd['AsyncRun'](cmd)
end

BASHCOMP_LOAD()

vim.cmd([[
fun! CompleteShell(argLead, cmdLine, curPos)
  return v:lua.SHELL_COMPLETION(a:cmdLine, a:curPos + 1)
endfun
]])

vim.api.nvim_create_user_command('R', run_cmd, {
  nargs = "*",
  complete = "custom,CompleteShell",
  bang = true
})

-- require("tabline").setup()

-- vim: ts=2 sts=2 sw=2 et
