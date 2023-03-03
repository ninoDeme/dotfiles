require('plugins')
-- ~/.config/nvim/lua/plugins.lua use <gf> to go to file

-- Plugin Setup {{{

if not vim.g.vscode then

  require 'nvim-web-devicons'.setup()

  require("lspsaga").setup({
    lightbulb = {
      enable = false,
    },
  })

  
  require('refactoring').setup({})

  local whichkey= require("which-key")
  whichkey.setup {}

  local luasnip = require('luasnip')

  local lspkind = require('lspkind')

  local cmp = require 'cmp' --{{{
  local cmp_map = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-u>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
  })
  cmp.setup {
    window = {
      completion = cmp.config.window.bordered({
        col_offset = -3,
        side_padding = 0,
      }),
      documentation = cmp.config.window.bordered()
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
    formatting = {
      fields = { "kind", "abbr", "menu" },
      format = function(entry, vim_item)
        local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
        local strings = vim.split(kind.kind, "%s", { trimempty = true })
        kind.kind = " " .. (strings[1] or "") .. " "
        kind.menu = "    (" .. (strings[2] or "") .. ")"
        return kind
      end,
    },
    experimental = {
      ghost_text = true
    }
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

  require("mason").setup()

  require("mason-lspconfig").setup({
    ensure_installed = {
      'lua_ls',
      'tsserver',
      'html'
    }
  })

  require("mason-null-ls").setup({
      ensure_installed = {
        'eslint_d',
      },
      automatic_installation = false,
      automatic_setup = false, -- Recommended, but optional
  })

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

  local lspconfig = require('lspconfig')


  -- lsp setup functions {{{
  local function keymappings(client, bufnr)
    local opts = { noremap = true, silent = true }

    -- lsp Key mappings
    -- vim.api.nvim_set_keymap("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

    vim.api.nvim_set_keymap("n", "gh", "<cmd>Lspsaga hover_doc<CR>", opts)

    vim.api.nvim_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.api.nvim_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    vim.api.nvim_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    vim.api.nvim_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

    vim.api.nvim_set_keymap("n", "<leader>tt", "<cmd>Lspsaga term_toggle<CR>", opts)

    -- Whichkey
    local keymap_l = {
      l = {
        name = "Code",
        -- r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        r = { "<cmd>Lspsaga rename<CR>", "Rename" },
        R = { "<cmd>Lspsaga rename ++project<CR>", "Rename for entire project" },
        -- a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
        d = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Diagnostics" },
        i = { "<cmd>LspInfo<CR>", "Lsp Info" },
        f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
      },
    }

      local keymap_g = {
        name = "Goto",
        d = { "<Cmd>Lspsaga goto_definition<CR>", "Goto Definition" },
        D = { "<Cmd>Lspsaga peek_definition<CR>", "Peek Definition" },
        ['c-d'] = { "<Cmd>Lspsaga goto__type_definition<CR>", "Goto Definition" },
        ['c-D'] = { "<Cmd>Lspsaga peek_type_definition<CR>", "Peek Definition" },
        H = { "<Cmd>Lspsaga lsp_finder<CR>", "Peek Definition" },
        s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      }
      whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>" })
      whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
    end

  local opts = {
    on_attach = function(client, bufnr)

      -- Use LSP as the handler for formatexpr.
      -- See `:help formatexpr` for more information. 'gq'
      vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

      -- Configure key mappings
      keymappings(client, bufnr)

    end,

    capabilities = require('cmp_nvim_lsp').default_capabilities()
  }
  -- }}}

  lspconfig.lua_ls.setup{
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
    on_attach = opts.on_attach,
    capabilities = opts.capabilities
  }

  lspconfig.angularls.setup(opts)
  lspconfig.tsserver.setup(opts)

  local signs = { Error = "", Warning = "", Hint = "", Information = "" }
  for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
  end

  -- require("bufferline").setup{}

  -- Nvim-Tree {{{
  require 'nvim-tree'.setup({
    view = {
      mappings = {
        list = {
          { key = "h", action = "dir_up"},
          { key = "l", action = "edit"},
          { key = "L", action = "cd"},
          { key = "<C-l>", action = "preview"},
        }
      }
    },
    actions = {
      open_file = {
        quit_on_open = false
      }
    }
  })

  -- }}}

  -- Lualine {{{
  require('lualine').setup {
    options = {
      theme = 'onedark',
      section_separators = '',
      component_separators = '│'
    }
  }
  -- }}}

  require('qf_helper').setup()

  -- TreeSitter {{{
  require 'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      disable = {
        'typescript',
        'javascript',
        'html',
        'lua'
      }
    },
    rainbow = {
      enable = true
    },
    indent = {
      enable = true,
    }
  }

  require 'treesitter-context'.setup { enable = true, throttle = true, }

  require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
  require 'nvim-treesitter.install'.prefer_git = false

  -- }}}


  require('kommentary.config').use_extended_mappings()

  whichkey.register({
    ['<leader>t']  = { name = 'Open numbered terminals' },
    ['<leader>t1'] = { name = 'Terminal 1' },
    ['<leader>t2'] = { name = 'Terminal 2' },
    ['<leader>t3'] = { name = 'Terminal 3' },
    ['<leader>t4'] = { name = 'Terminal 4' },
    ['<leader>tt'] = { name = 'Toggle terminal (lsp)' },
    ['<leader>s']  = { name = 'Telescope' },
    ['<leader>sb'] = { name = 'Buffers' },
    ['<leader>ss'] = { name = 'Grep' },
    ['gl']         = { name = 'Align text at (right)' },
    ['gL']         = { name = 'Align text at (left)' },
    ['s']          = { name = 'Vim sneak' },
    ['S']          = { name = 'Vim sneak' },
    ['<leader>W']  = { name = 'Create dir to current file' },
  })

end

vim.keymap.set("n", "gr", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("n", "grr", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "gR", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
vim.keymap.set("x", "gr", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })


vim.keymap.set("n", "cx", "<cmd>lua require('substitute.exchange').operator()<cr>", { noremap = true })
vim.keymap.set("n", "cxx", "<cmd>lua require('substitute.exchange').line()<cr>", { noremap = true })
vim.keymap.set("x", "cx", "<cmd>lua require('substitute.exchange').visual()<cr>", { noremap = true })
vim.keymap.set("n", "cxc", "<cmd>lua require('substitute.exchange').cancel()<cr>", { noremap = true })

-- }}}

-- Vim settings {{{

-- map leader to space
vim.g.mapleader = " "

-- use system clipboard
vim.api.nvim_set_option("clipboard","unnamedplus")


if vim.g.neovide then

  vim.opt.guifont =  "JetBrains Mono:h10" 
  vim.g.onedark_terminal_italics = 1

end

if not vim.g.vscode then

  -- set coloscheme
  vim.opt.termguicolors = true
  -- vim.cmd [[colorscheme modus-vivendi]]
  vim.cmd [[

    let ayucolor="dark"
    colorscheme ayu
    " hi Normal guibg=NONE ctermbg=NONE

   ]]

  require('colors')
end

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
set completeopt=menu,menuone,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

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
nnoremap <leader>r :source $MYVIMRC<CR>

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

  noremap <leader><leader> :NvimTreeToggle<CR>
  noremap <leader>e :NvimTreeFocus<CR>

  " Telescope bindings
  nnoremap <leader>ss <cmd>Telescope live_grep<cr>
  nnoremap <leader>sb <cmd>Telescope buffers<cr>

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

  " Go to next buffer (alt-tab equivalent)
  noremap <silent> gt :BufferNext<CR>
  noremap <silent> gT :BufferPrev<CR>

  nnoremap <silent>    <A-1> <Cmd>BufferGoto 1<CR>
  nnoremap <silent>    <A-2> <Cmd>BufferGoto 2<CR>
  nnoremap <silent>    <A-3> <Cmd>BufferGoto 3<CR>
  nnoremap <silent>    <A-4> <Cmd>BufferGoto 4<CR>
  nnoremap <silent>    <A-5> <Cmd>BufferGoto 5<CR>
  nnoremap <silent>    <A-6> <Cmd>BufferGoto 6<CR>
  nnoremap <silent>    <A-7> <Cmd>BufferGoto 7<CR>
  nnoremap <silent>    <A-8> <Cmd>BufferGoto 8<CR>
  nnoremap <silent>    <A-9> <Cmd>BufferGoto 9<CR>
  nnoremap <silent>    <A-0> <Cmd>BufferLast<CR>

  " close current buffer
  nnoremap <silent> <Leader>wq :lua require("nvim-smartbufs").close_current_buffer()<CR>

  " open numbered terminals
  nnoremap <silent> <Leader>t1 :lua require("nvim-smartbufs").goto_terminal(1)<CR>
  nnoremap <silent> <Leader>t2 :lua require("nvim-smartbufs").goto_terminal(2)<CR>
  nnoremap <silent> <Leader>t3 :lua require("nvim-smartbufs").goto_terminal(3)<CR>
  nnoremap <silent> <Leader>t4 :lua require("nvim-smartbufs").goto_terminal(4)<CR>

  nnoremap <silent> <Leader><return> :!alacritty &<CR>

  
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
