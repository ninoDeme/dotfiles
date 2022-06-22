require('plugins')

-- plugin setup
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
local lspconfig = require('lspconfig')
local lspkind = require('lspkind')
local cmp = require 'cmp'
cmp.setup { --{{{
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
--      elseif luasnip.expand_or_jumpable() then
--        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text', -- show only symbol annotations
    })
  }
} --}}}

require("dapui").setup()

local luasnip = require 'luasnip'

require 'nvim-tree'.setup()

require('lualine').setup {
  options = {
    theme = 'codedark',
    section_separators = '',
    component_separators = '│'
  }
}

-- require ('colorizer').setup {
  --[[ 'css';
  'javascript';
  'html'
} ]]

local null_ls = require("null-ls")
local prettier = require("prettier")

--[[ null_ls.setup({
  on_attach = function(client, bufnr)
    if client.resolved_capabilities.document_formatting then
      vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.format( async == true )<CR>")
      -- format on save
      -- vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    end

    if client.resolved_capabilities.document_range_formatting then
      vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
    end
  end,
}) ]]


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

require('gitsigns').setup {
  signcolumn = true,
  numhl = true,
  current_line_blame = true,
}

require("bufferline").setup {}

require('kommentary.config').use_extended_mappings()

require 'qf_helper'.setup()

require 'nvim-treesitter.configs'.setup {
  rainbow = {
    enable = true
  }
}
require 'treesitter-context'.setup { enable = true, throttle = true, }


require 'nvim-web-devicons'.setup()

vim.cmd([[
set notimeout

filetype plugin indent on

autocmd FileType org setlocal iskeyword+=:,#,+
autocmd BufEnter * lua require'completion'.on_attach()
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()

set termguicolors

if has('mouse')
	set mouse=a
endif
]])

-- map leader to space
vim.g.mapleader = " "

-- plugin options
vim.g.dashboard_default_executive = "telescope"
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })

-- set coloscheme
vim.opt.termguicolors = true
vim.cmd [[colorscheme modus-vivendi]]

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

vim.cmd([[
" Press ESC to clear search
nnoremap <silent> <ESC> :nohlsearch<CR><ESC>

" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

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
nnoremap <leader>sv :source $MYVIMRC<CR>

" DAP mode bindings
noremap <silent> <leader>dd :lua require("dapui").toggle("sidebar")<CR>
noremap <silent> <F5> :lua require'dap'.continue()<CR>
noremap <silent> <leader>db :lua require'dap'.toggle_breakpoint()<CR>

" Go to next buffer (alt-tab equivalent)
noremap <silent> <leader><Tab> :BufferLineCycleNext<CR>

" close current buffer
nnoremap <silent> <Leader>qq :lua require("nvim-smartbufs").close_current_buffer()<CR>

" open numbered terminals
nnoremap <Leader>t1 :lua require("nvim-smartbufs").goto_terminal(1)<CR>
nnoremap <Leader>t2 :lua require("nvim-smartbufs").goto_terminal(2)<CR>
nnoremap <Leader>t3 :lua require("nvim-smartbufs").goto_terminal(3)<CR>
nnoremap <Leader>t4 :lua require("nvim-smartbufs").goto_terminal(4)<CR>

" esc to exit terminal mode
tnoremap <Esc> <C-\><C-n>

" use CTRL+ALT+movement keys to navigate windows in all modes {{{
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
" }}}
]])
-- vim: ts=2 sts=2 sw=2 et
