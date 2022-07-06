require('plugins')
-- ~/.config/nvim/lua/plugins.lua use <gf> to go to file

-- Plugin Setup {{{

local luasnip = require 'luasnip'

local lspconfig = require('lspconfig')

local lsp_installer = require("nvim-lsp-installer") --{{{

-- Register a handler that will be called for each installed server when it's ready (i.e. when installation is finished
-- or if the server is already installed).
lsp_installer.on_server_ready(function(server)
  local opts = {}

  -- (optional) Customize the options passed to the server
  -- if server.name == "tsserver" then
  --     opts.root_dir = function() ... end
  -- end

  -- This setup() function will take the provided server configuration and decorate it with the necessary properties
  -- before passing it onwards to lspconfig.
  -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
  server:setup(opts)
end) --}}}

local lspkind = require('lspkind')

local cmp = require 'cmp' --{{{
local cmp_map = cmp.mapping.preset.insert({
  ['<C-d>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-Space>'] = cmp.mapping.complete(),
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<C-l>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<C-j>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_next_item()
   elseif luasnip.expand_or_jumpable() then
     luasnip.expand_or_jump()
    else
      fallback()
    end
  end, { 'i', 's' }),
  ['<C-k>'] = cmp.mapping(function(fallback)
    if cmp.visible() then
      cmp.select_prev_item()
    elseif luasnip.jumpable(-1) then
      luasnip.jump(-1)
    else
      fallback()
    end
  end, { 'i', 's' }),
})
cmp.setup { 
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp_map,
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'treesitter' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
    })
  }
}
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
local misc = require('cmp.utils.misc')
local command_line_map = cmp.mapping.preset.cmdline({ 
  ['<Tab>'] = {
    c = function()
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item()
      else
        feedkeys.call(keymap.t('<C-z>'), 'n')
      end
    end,
  },
  ['<S-Tab>'] = {
    c = function()
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_prev_item()
      else
        feedkeys.call(keymap.t('<C-z>'), 'n')
      end
    end,
  },
  ['<C-j>'] = {
    c = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback()
      end
    end,
  },
  ['<C-k>'] = {
    c = function(fallback)
      local cmp = require('cmp')
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end,
  },
  ['<CR>'] = cmp.mapping.confirm {
    behavior = cmp.ConfirmBehavior.Replace,
    select = true,
  },
  ['<C-e>'] = {
    c = cmp.mapping.close(),
  },
})
cmp.setup.cmdline(':', {
  mapping = command_line_map,
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
--}}}

-- Nvim-Tree {{{
require 'nvim-tree'.setup({
  view = {
    mappings = {
      list = {
        { key = "h", action = "dir_up"},
        { key = "l", action = "edit"},
        { key = "<C-l>", action = "preview"},
      }
    }
  },
  actions = {
    open_file = {
      quit_on_open = true
    }  
  }
})
-- }}}

-- Lualine {{{
require('lualine').setup {
  options = {
    theme = 'codedark',
    section_separators = '',
    component_separators = '│'
  }
}
-- }}}

-- Prettier {{{
local prettier = require("prettier")

prettier.setup({
  bin = 'prettier', -- or `prettierd`
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },

  -- prettier format options (you can use config files too. ex: `.prettierrc`)
  arrow_parens = "always",
  bracket_spacing = true,
  embedded_language_formatting = "auto",
  end_of_line = "lf",
  html_whitespace_sensitivity = "css",
  jsx_bracket_same_line = false,
  jsx_single_quote = false,
  print_width = 80,
  prose_wrap = "preserve",
  quote_props = "as-needed",
  semi = true,
  single_quote = false,
  tab_width = 2,
  trailing_comma = "es5",
  use_tabs = false,
  vue_indent_script_and_style = false,
})
--- }}}

--- Git Singns {{{
require('gitsigns').setup {
  signcolumn = true,
  numhl = true,
  current_line_blame = true,
}
--- }}}

require("bufferline").setup {}

require('kommentary.config').use_extended_mappings()

require 'qf_helper'.setup()

-- TreeSitter {{{
require 'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  rainbow = {
    enable = true
  },
  indent = {
    enable = true,
  }
}
-- }}}

require 'treesitter-context'.setup { enable = true, throttle = true, }

require 'nvim-web-devicons'.setup()
-- }}}

-- Vim settings {{{
-- map leader to space
vim.g.mapleader = " "

-- set coloscheme
vim.opt.termguicolors = true
-- vim.cmd [[colorscheme modus-vivendi]]
vim.cmd [[
let ayucolor="dark"
colorscheme ayu
hi Normal guibg=NONE ctermbg=NONE
]]

vim.opt.wildmenu = true

-- Set highlight on search
vim.opt.hlsearch = true

-- deal with case sensitivity on search
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.hidden = true
vim.opt.ruler = true
vim.opt.laststatus = 2
vim.opt.confirm = true
vim.opt.visualbell = true

-- add manual folding
vim.opt.foldmethod = 'marker'
vim.opt.cmdheight = 2
vim.opt.number = true
vim.opt.relativenumber = true

-- save undo history
vim.opt.undofile = true
-- }}}

-- Vimscript {{{
vim.cmd([[

set notimeout

filetype plugin indent on

autocmd FileType org setlocal iskeyword+=:,#,+
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

set termguicolors

if has('mouse')
	set mouse=a
endif

" Keybindings {{{

" Press ESC to clear search
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menu,menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

noremap <leader><leader> :NvimTreeToggle<CR>

nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format( async == true )<CR>
" copy and paste from system clipboard
noremap <Leader>Y "*y
noremap <Leader>P "*p
noremap <Leader>y "+y
noremap <Leader>p "+p

" reload config
nnoremap <leader>r :source $MYVIMRC<CR>

" Telescope bindings
nnoremap <leader>ss <cmd>Telescope live_grep<cr>
nnoremap <leader>sb <cmd>Telescope buffers<cr>

" Easy align keybindings
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" DAP mode bindings
" noremap <silent> <leader>dd :lua require("dapui").toggle("sidebar")<CR>
" noremap <silent> <F5> :lua require'dap'.continue()<CR>
" noremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>

" qf_helper bindings
nnoremap <silent> <C-N> <cmd>QNext<CR>
nnoremap <silent> <C-P> <cmd>QPrev<CR>
" toggle the quickfix open/closed without jumping to it
nnoremap <silent> <leader>q <cmd>QFToggle!<CR>
nnoremap <silent> <leader>l <cmd>LLToggle!<CR>

" Go to next buffer (alt-tab equivalent)
noremap <silent> <leader><Tab> :BufferLineCycleNext<CR>

" close current buffer
nnoremap <silent> <Leader>qq :lua require("nvim-smartbufs").close_current_buffer()<CR>

" open numbered terminals
nnoremap <silent> <Leader>t1 :lua require("nvim-smartbufs").goto_terminal(1)<CR>
nnoremap <silent> <Leader>t2 :lua require("nvim-smartbufs").goto_terminal(2)<CR>
nnoremap <silent> <Leader>t3 :lua require("nvim-smartbufs").goto_terminal(3)<CR>
nnoremap <silent> <Leader>t4 :lua require("nvim-smartbufs").goto_terminal(4)<CR>

nnoremap <silent> <Leader><return> :!alacritty &<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use CTRL+ALT+movement keys to navigate windows in all modes 
tnoremap <silent><C-A-h> <C-\><C-N><C-w>h
tnoremap <silent><C-A-j> <C-\><C-N><C-w>j
tnoremap <silent><C-A-k> <C-\><C-N><C-w>k
tnoremap <silent><C-A-l> <C-\><C-N><C-W>l
inoremap <silent><C-A-h> <C-\><C-N><C-w>h
inoremap <silent><C-A-j> <C-\><C-N><C-w>j
inoremap <silent><C-A-k> <C-\><C-N><C-w>k
inoremap <silent><C-A-l> <C-\><C-N><C-w>l
nnoremap <silent><C-A-h> <C-w>h
nnoremap <silent><C-A-j> <C-w>j
nnoremap <silent><C-A-k> <C-w>k
nnoremap <silent><C-A-l> <C-w>l
]])
-- }}} }}}
-- vim: ts=2 sts=2 sw=2 et
