vim.cmd([[
  autocmd VimEnter * if argc() > 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0]) | endif
]])

-- vim.cmd('source ' .. vim.fn.stdpath("config") .. '/autoload/firebird.vim')

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
    change_scale_factor(1/1.05)
  end)
end

if vim.g.vscode then

  vim.keymap.set({'n', 'v', 'x'}, 'gc', "<Plug>VSCodeCommentary<CR>")
  vim.keymap.set('n', 'gcc', "<Plug>VSCodeCommentaryLine<CR>")

end

require("hover").setup('light')

-- Vim settings {{{

local diagnostic_config = {
  text = {},
  texthl = {},
  linehl = {},
  numhl = {},
}

-- local signs = {
--   DapBreakpoint = { "", "DapBreakpoint" },
--   DapBreakpointCondition = { "", "DapBreakpointCondition" },
--   DapLogPoint = { "", "DapLogPoint" },
--   DapStopped = { "", "DapStopped", "DapStoppedLine" },
--   DapBreakpointRejected = { "", "DapBreakpointRejected" },
--   Error = {44,  " ", "Error", "Error", nil, "Error" },
--   Warn = {44,  " ", "Warn", "Warn", nil, "Warn" },
--   Hint = {44,  " ", "Hint", "Hint", nil, "Hint" },
--   Info = {44,  " ", "Info", "Info", nil, "Info" },
-- }
--
-- for key, val in ipairs(signs) do
--   diagnostic_config["text"][key] = val[1]
--   diagnostic_config["texthl"][key] = val[2]
--   diagnostic_config["linehl"][key] = val[3]
--   diagnostic_config["numhl"][key] = val[4]
-- end
-- vim.diagnostic.config({
--   signs = diagnostic_config
-- })

-- use system clipboard
-- vim.api.nvim_set_option("clipboard","unnamedplus")

-- map leader to space
vim.g.mapleader = " "
vim.opt.termguicolors = true
vim.opt.guifont =  "Iosevka Nerd Font:h10"
vim.opt.linespace = 1
vim.opt.wildmenu       = true

-- Set highlight on search
vim.opt.hlsearch       = true

-- deal with case sensitivity on search
vim.opt.ignorecase     = true
vim.opt.smartcase      = true

vim.opt.hidden         = true
vim.opt.ruler          = true
vim.opt.confirm        = true
vim.opt.visualbell     = true

-- -- add manual folding
-- vim.opt.foldmethod     = 'marker'
--
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false
vim.opt.foldlevel = 40

vim.opt.cmdheight      = 1
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3

vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.expandtab      = true

vim.opt.signcolumn     = 'yes'

vim.opt.cursorline     = true

vim.opt.scrolloff      = 3

vim.opt.wrap = false
-- vim.opt.timeout = false
-- vim.opt.timeoutlen = 300

vim.opt.backupcopy     = 'yes'

vim.opt.linebreak      = true
-- save undo history
vim.opt.undofile       = true

-- fix vim screen geometry on alacritty -e nvim
if (os.getenv("TERM") == "alacritty") then
  vim.api.nvim_create_autocmd({"VimEnter"}, {
    callback = function()
      local pid, WINCH = vim.fn.getpid(), vim.uv.constants.SIGWINCH
      vim.defer_fn(function() vim.uv.kill(pid, WINCH) end, 10)
    end
  })
end

-- press tab to jump snippet
vim.keymap.set({ 'i', 's' }, '<Tab>', function()
  if vim.snippet.active({ direction = 1 }) then
    return '<cmd>lua vim.snippet.jump(1)<cr>'
  else
    return '<Tab>'
  end
end, { expr = true })

vim.keymap.set({'n'}, '<Leader>y', '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set({'n'}, '<Leader>p', '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({'n'}, '<Leader>Y', '"+y$')
vim.keymap.set({'n'}, '<Leader>P', '"+p$')

-- }}}

-- Vimscript {{{
vim.cmd([[

let g:VM_theme = 'iceblue'

au TextYankPost * silent! lua vim.highlight.on_yank()

filetype plugin indent on

set termguicolors

if has('mouse')
  set mouse=a
endif

" Keybindings {{{

" Press ESC to clear search
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

" Set completeopt to have a better completion experience
set completeopt=menu,menuone,noselect,noinsert

" Use fold as text object for motions
xnoremap iz :<C-U>silent!normal![zjV]zk<CR>
onoremap iz :normal Viz<CR>
xnoremap az :<C-U>silent!normal![zV]z<CR>
onoremap az :normal Vaz<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

if executable('rg') 
	set grepprg=rg\ --vimgrep
endif

]])
-- }}} }}}


function NOT_VSCODE()
  return not vim.g.vscode
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
    fallback = true
  },
  defaults = {
    lazy = true
  },
})

-- vim: ts=2 sts=2 sw=2 et
