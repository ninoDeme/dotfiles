vim.cmd([[
  autocmd VimEnter * if argc() > 0 && isdirectory(argv()[0]) | execute 'cd' fnameescape(argv()[0]) | endif
]])
-- map leader to space
vim.g.mapleader = " "

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
  }
})
-- ~/.config/nvim/lua/plugins.lua use <gf> to go to file

-- Plugin Setup {{{

if vim.g.neovide then

  vim.opt.guifont =  "JetBrains Mono:h10"
end

if vim.g.vscode then

  vim.keymap.set({'n', 'v', 'x'}, 'gc', "<Plug>VSCodeCommentary<CR>")
  vim.keymap.set('n', 'gcc', "<Plug>VSCodeCommentaryLine<CR>")

else

  -- set coloscheme
  vim.opt.termguicolors = true
  vim.cmd [[

    let ayucolor="dark"
    colorscheme ayu
    " hi Normal guibg=NONE ctermbg=NONE

   ]]

  require('onedark').setup {
    style = 'darker'
  }
  require('onedark').load()

  require('colors')

  require 'nvim-web-devicons'.setup()

  require('refactoring').setup({})

  local whichkey= require("which-key")

  local luasnip = require('luasnip')


  local cmp = require 'cmp' --{{{
  local cmp_map = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),
    ['<C-e>'] = cmp.mapping.scroll_docs(1),
    ['<C-y>'] = cmp.mapping.scroll_docs(-1),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-l>'] = cmp.mapping.confirm(),
  })
  -- Configure key mappings
  --
  require('lspkind').init({
    preset = "codicons"
  })
  cmp.setup {
    window = {
      completion = {
        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
        col_offset = -3,
        side_padding = 0,
      }
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp_map,
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      { name = 'treesitter' },
      { name = 'nvim_lsp_signature_help' }
    },
      { name = 'buffer' }),
    experimental = {
      -- ghost_text = true
    },
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "text_symbol", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[2] or "") .. " "
        kind.menu = "    (" .. (strings[1] or "") .. ")"
        return kind
      end,
    },
  }
  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  -- local misc = require('cmp.utils.misc')
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
        { name = 'cmdline' }
      })
  })
  --}}}

  --- Git Singns {{{
  require('gitsigns').setup {
    signcolumn = true,
    numhl = true,
    current_line_blame = true,
  }
  --- }}}

  local temEslint = {
    condition = function(utils)
      return utils.root_has_file({".eslintrc.json", ".eslintrc.js"})
    end,
  }
  local null_ls = require("null-ls")
  null_ls.setup({
    sources = {
      null_ls.builtins.code_actions.gitrebase,
      null_ls.builtins.code_actions.gitsigns,
      null_ls.builtins.code_actions.refactoring,
      null_ls.builtins.diagnostics.tsc,
      null_ls.builtins.diagnostics.eslint_d.with(temEslint),
      null_ls.builtins.formatting.eslint_d.with(temEslint),
      null_ls.builtins.code_actions.eslint_d.with(temEslint)
    }
  })


  require('qf_helper').setup()

  whichkey.register({
    t  = { name = '+Toggle Numbered Terminals', },
    b = { name = '+Buffers', },
    W = { 'Create dir to current file' },
  }, {prefix = '<leader>'})

  whichkey.register({
    s = { 'Vim sneak' },
    S = { 'Vim sneak' },
    g = {
      l = { 'Align text at (right)' },
      L = { 'Align text at (left)' },
    }
  })

end

-- }}}

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
vim.opt.laststatus     = 2
vim.opt.confirm        = true
vim.opt.visualbell     = true

-- add manual folding
vim.opt.foldmethod     = 'marker'

vim.opt.cmdheight      = 1
vim.opt.number         = true
vim.opt.relativenumber = true

vim.opt.tabstop        = 2
vim.opt.shiftwidth     = 2
vim.opt.softtabstop    = 2
vim.opt.expandtab      = true

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
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p

" Delete without copying
nnoremap <leader>d "_d
xnoremap <leader>d "_d
nnoremap <leader>D "_D
xnoremap <leader>D "_D

" Create directory for current file
noremap <leader>W <Cmd>:call mkdir(expand("%:p:h"),"p")<CR>

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

  " qf_helper bindings
  nnoremap <silent> <C-N> <cmd>QNext<CR>
  nnoremap <silent> <C-P> <cmd>QPrev<CR>

  " toggle the quickfix open/closed without jumping to it
  nnoremap <silent> <leader>q <cmd>QFToggle!<CR>
  nnoremap <silent> <leader>L <cmd>LLToggle!<CR>

  
endif

" Regexes
" Note that all regexes are surrounded by (), use that to your advantage.

" Teste usar lookbehind para verificar se não é o nome da tag
" A word: `attr=value`, with no quotes.
let s:RE_WORD = '\(\w\+\)'
" An attribute name: `src`, `data-attr`, `strange_attr`.
let s:RE_ATTR_NAME = '\([\[\(\#\*]\{0,2}\)\([a-zA-Z0-9\-_:@.]\+\)\([\]\)]\{0,2}\)'
" A quoted string.
let s:RE_QUOTED_STR = '\(".\{-}"\)'
" The value of an attribute: a word with no quotes or a quoted string.
let s:RE_ATTR_VALUE = '\(' . s:RE_QUOTED_STR . '\|' . s:RE_WORD . '\)'
" The right-hand side of an XML attr: an optional `=something` or `="str"`.
let s:RE_ATTR_RHS = '\(=' . s:RE_ATTR_VALUE . '\)\='

" The final regex.
let s:RE_ATTR_I = '\(' . s:RE_ATTR_NAME . s:RE_ATTR_RHS . '\)'
let s:RE_ATTR_A = '\s\+' . s:RE_ATTR_I
let s:RE_ATTR_AX = '\s\+' . s:RE_ATTR_NAME

call textobj#user#plugin('angularattr', {
\   'attr-i': {
\     'pattern': s:RE_ATTR_I,
\     'select': 'ix',
\   },
\   'attr-a': {
\     'pattern': s:RE_ATTR_A,
\     'select': 'ax',
\   },
\   'attr-iX': {
\     'pattern': s:RE_ATTR_NAME,
\     'select': 'iX'
\   },
\   'attr-aX': {
\     'pattern': s:RE_ATTR_AX,
\     'select': 'aX'
\   },
\ })

]])
-- }}} }}}

-- vim: ts=2 sts=2 sw=2 et
