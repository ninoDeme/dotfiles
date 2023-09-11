vim.cmd([[
  autocmd VimEnter * if argc() > 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0]) | endif
]])
-- map leader to space
vim.g.mapleader = " "

vim.opt.laststatus = 3

vim.opt.termguicolors = true

function NOT_VSCODE()
  return not vim.g.vscode
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
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
    path = "~/projects",
    fallback = true
  },
  defaults = {
    lazy = true
  }
})

vim.opt.guifont =  "JetBrainsMono Nerd Font:h9"

if vim.g.neovide then
  vim.g.neovide_scale_factor = 1.0
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

else

end

-- Vim settings {{{

-- use system clipboard
-- vim.api.nvim_set_option("clipboard","unnamedplus")

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

-- add manual folding
vim.opt.foldmethod     = 'marker'

vim.opt.cmdheight      = 1
vim.opt.number         = true
vim.opt.relativenumber = true
vim.opt.laststatus = 3

vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.expandtab      = true

vim.opt.scrolloff      = 4

vim.opt.wrap = false
-- vim.opt.timeout = false
-- vim.opt.timeoutlen = 300

vim.opt.linebreak      = true
-- save undo history
vim.opt.undofile       = true

-- fix vim screen geometry on alacritty -e nvim
if (os.getenv("TERM") == "alacritty") then
  vim.api.nvim_create_autocmd({"VimEnter"}, {
    callback = function()
      local pid, WINCH = vim.fn.getpid(), vim.loop.constants.SIGWINCH
      vim.defer_fn(function() vim.loop.kill(pid, WINCH) end, 10)
    end
  })
end

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

" copy and paste from system clipboard
noremap <Leader>Y "+y$
noremap <Leader>P "+p$
noremap <Leader>y "+y
noremap <Leader>p "+p

" Delete without copying
" nnoremap <leader>d "_d
" xnoremap <leader>d "_d
" nnoremap <leader>D "_D
" xnoremap <leader>D "_D

" reload config
" nnoremap <leader>r :source $MYVIMRC<CR>

" Use fold as text object for motions
" xnoremap iz :<C-U>silent!normal![zV]z<CR>
" onoremap iz :normal viz<CR>

xnoremap iz :<C-U>silent!normal![zjV]zk<CR>
onoremap iz :normal Viz<CR>
xnoremap az :<C-U>silent!normal![zV]z<CR>
onoremap az :normal Vaz<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

if !exists('g:vscode')

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" DAP mode bindings
" noremap <silent> <leader>dd :lua require("dapui").toggle("sidebar")<CR>
" noremap <silent> <F5> :lua require'dap'.continue()<CR>
" noremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>

endif

]])
-- }}} }}}

-- vim: ts=2 sts=2 sw=2 et
