require('plugins')
-- ~/.config/nvim/lua/plugins.lua use <gf> to go to file

-- Plugin Setup {{{

if vim.g.neovide then

  vim.opt.guifont =  "JetBrains Mono:h10"
  vim.g.onedark_terminal_italics = 1

end

if vim.g.vscode then

  vim.keymap.set('n', 'gzd', "<Cmd>call VSCodeNotify('eitor.action.addSelectionToNextFindMatch')<CR>", {noremap = true})
  vim.keymap.set('n', 'gzD', "<Cmd>call VSCodeNotify('editor.action.addSelectionToPreviousFindMatch')<CR>", {noremap = true})
  vim.keymap.set('n', 'gzj', "<Cmd>call VSCodeNotify('editor.action.insertCursorBelow')<CR>", {noremap = true})
  vim.keymap.set('n', 'gzk', "<Cmd>call VSCodeNotify('editor.action.insertCursorAbove')<CR>", {noremap = true})
  vim.keymap.set('n', 'gzm', "<Cmd>call VSCodeNotify('addCursorsAtSearchResults')<CR>", {noremap = true})
  vim.keymap.set('n', 'gzm', "<Cmd>call VSCodeNotify('cursorUndo')<CR>", {noremap = true})

else

  -- set coloscheme
  vim.opt.termguicolors = true
  vim.cmd [[

    let ayucolor="dark"
    colorscheme ayu
    " hi Normal guibg=NONE ctermbg=NONE

   ]]

  require('onedark').setup { style = 'darker' }
  require('onedark').load()

  require('colors')

  require 'nvim-web-devicons'.setup()

  require('refactoring').setup({})

  local whichkey= require("which-key")
  -- whichkey.setup {}

  local luasnip = require('luasnip')

  vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282C34", fg = "NONE" })
  vim.api.nvim_set_hl(0, "Pmenu", { fg = "#C5CDD9", bg = "#22252A" })

  vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { fg = "#7E8294", bg = "NONE", strikethrough = true })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#82AAFF", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#82AAFF", bg = "NONE", bold = true })
  vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#C792EA", bg = "NONE", italic = true })

  vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#EED8DA", bg = "#B5585F" })
  vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#EED8DA", bg = "#B5585F" })
  vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#EED8DA", bg = "#B5585F" })

  vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#f3ffeD", bg = "#7F9D63" })
  vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#f3ffeD", bg = "#7F9D63" })
  vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#f3ffeD", bg = "#7F9D63" })

  vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#FFE592", bg = "#D4BB6C" })
  vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#FFE592", bg = "#D4BB6C" })
  vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#FFE592", bg = "#D4BB6C" })

  vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#EADFF0", bg = "#A377BF" })
  vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#EADFF0", bg = "#A377BF" })
  vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#EADFF0", bg = "#A377BF" })
  vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#EADFF0", bg = "#A377BF" })
  vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#EADFF0", bg = "#A377BF" })

  vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#C5CDD9", bg = "#7E8294" })
  vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#C5CDD9", bg = "#7E8294" })

  vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#F5EBD9", bg = "#D4A959" })
  vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#F5EBD9", bg = "#D4A959" })
  vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#F5EBD9", bg = "#D4A959" })

  vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#DDE5F5", bg = "#6C8ED4" })
  vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#DDE5F5", bg = "#6C8ED4" })
  vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#DDE5F5", bg = "#6C8ED4" })

  vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#D8EEEB", bg = "#58B5A8" })
  vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#D8EEEB", bg = "#58B5A8" })
  vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#D8EEEB", bg = "#58B5A8" })

  local cmp = require 'cmp' --{{{
  local cmp_map = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),
    ['<C-y>'] = cmp.mapping.scroll_docs(1),
    ['<C-e>'] = cmp.mapping.scroll_docs(-1),
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

  local neogit = require("neogit")

  neogit.setup({})

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
    vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    vim.keymap.set("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    vim.keymap.set("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

    -- Whichkey
    local keymap_l = {
      l = {
        name = "Code",
        r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
        i = { "<cmd>LspInfo<CR>", "Lsp Info" },
        f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
      },
    }

      local keymap_g = {
        name = "Goto",
        d = { "<cmd>Telescope lsp_definitions<CR>", "Definitions"},
        D = { "<cmd>Telescope lsp_references<CR>", "References"},
        s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
        I = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      }
      whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>" })
      whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
    end

  local lsp_opts = {
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
    on_attach = lsp_opts.on_attach,
    capabilities = lsp_opts.capabilities
  }

  lspconfig.angularls.setup(lsp_opts)
  lspconfig.tsserver.setup(lsp_opts)

  local signs = { Error = "", Warn = "", Hint = "", Info = "" }
  for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
  end

  -- Nvim-Tree {{{
  require 'nvim-tree'.setup({
    sync_root_with_cwd = true,
    actions = {
      open_file = {
        quit_on_open = false
      }
    },
    update_focused_file = {
      enable = true,
    },
    on_attach = function(bufnr)
      local api = require("nvim-tree.api")

      local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      local function edit_or_open()
        local node = api.tree.get_node_under_cursor()

        if node.nodes ~= nil then
          -- expand or collapse folder
          api.node.open.edit()
        else
          -- open file
          api.node.open.edit()
          -- Close the tree if file was opened
          api.tree.close()
        end
      end

      vim.keymap.set('n', 'x',     api.fs.cut,                        opts('Cut'))
      vim.keymap.set('n', 'p',     api.fs.paste,                      opts('Paste'))
      vim.keymap.set('n', 'a',     api.fs.create,                     opts('Create'))
      vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node,      opts('CD'))
      vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
      vim.keymap.set('n', 'K',     api.node.show_info_popup,          opts('Info'))
      vim.keymap.set('n', '<C-r>', api.fs.rename_sub,                 opts('Rename: Omit Filename'))
      vim.keymap.set('n', '<C-t>', api.node.open.tab,                 opts('Open: New Tab'))
      vim.keymap.set('n', '<C-v>', api.node.open.vertical,            opts('Open: Vertical Split'))
      vim.keymap.set('n', '<C-s>', api.node.open.horizontal,          opts('Open: Horizontal Split'))
      vim.keymap.set('n', '.',     api.node.run.cmd,                  opts('Run Command'))
      vim.keymap.set('n', 'c',     api.fs.copy.node,                  opts('Copy'))
      vim.keymap.set('n', 'y',     api.fs.copy.filename,              opts('Copy Name'))
      vim.keymap.set('n', 'Y',     api.fs.copy.relative_path,         opts('Copy Relative Path'))
      vim.keymap.set('n', 'd',     api.fs.remove,                     opts('Delete'))
      vim.keymap.set('n', 'D',     api.fs.trash,                      opts('Trash'))
      vim.keymap.set('n', '?',     api.tree.toggle_help,              opts('Help'))
      vim.keymap.set('n', 'q',     api.tree.close,                    opts('Close'))
      vim.keymap.set('n', 'r',     api.fs.rename,                     opts('Rename'))
      vim.keymap.set('n', 'R',     api.tree.reload,                   opts('Refresh'))
      vim.keymap.set('n', 's',     api.node.run.system,               opts('Run System'))
      vim.keymap.set('n', 'S',     api.tree.search_node,              opts('Search'))
      vim.keymap.set("n", "l",     edit_or_open,                      opts("Edit Or Open"))
      vim.keymap.set('n', '<CR>',  api.node.open.edit,                opts('Edit'))
      vim.keymap.set("n", "L",     api.node.open.preview,             opts("Vsplit Preview"))
      vim.keymap.set("n", "h",     api.tree.close,                    opts("Close"))
      vim.keymap.set("n", "H",     api.tree.collapse_all,             opts("Collapse All"))
    end
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

  vim.g.barbar_auto_setup = false -- disable auto-setup
  require'barbar'.setup({
    sidebar_filetypes = {
      NvimTree = true,
    }
  })

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

  local telescope = require("telescope")
  telescope.load_extension("zf-native")

  telescope.setup({
    pickers = {
      find_files = {
        theme = 'ivy'
      },
      grep = {
        theme = 'ivy'
      },
        buffers = {
        theme = 'ivy'
      }
    }
  })

  whichkey.register({
    t  = {
      name = '+Toggle Numbered Terminals',
      ['1'] = {'<cmd>ToggleTerm 1<CR>', 'Toggle Term 1'},
      ['2'] = {'<cmd>ToggleTerm 2<CR>', 'Toggle Term 2'},
      ['3'] = {'<cmd>ToggleTerm 3<CR>', 'Toggle Term 3'},
      ['4'] = {'<cmd>ToggleTerm 4<CR>', 'Toggle Term 4'},
      ['5'] = {'<cmd>ToggleTerm 5<CR>', 'Toggle Term 5'},
      ['6'] = {'<cmd>ToggleTerm 6<CR>', 'Toggle Term 6'},
      ['7'] = {'<cmd>ToggleTerm 7<CR>', 'Toggle Term 7'},
      ['8'] = {'<cmd>ToggleTerm 8<CR>', 'Toggle Term 8'},
      ['9'] = {'<cmd>ToggleTerm 9<CR>', 'Toggle Term 9'},
    },
    s  = {
      name = 'Telescope',
      s = {"<cmd>Telescope live_grep<cr>", 'Grep' },
      b = {"<cmd>Telescope buffers<cr>", 'Buffers' },
      f = {"<cmd>Telescope find_files<cr>", 'Find Files' },
    },
    b = {
      name = '+Buffers',
      x = {'<cmd>BufferClose<CR>', 'Close Current Buffer'},
      b = {'<cmd>BufferPick<CR>', 'Pick Buffer...'},
      q = {'<cmd>BufferPickDelete<CR>', 'Close Buffer...'},
      p = {'<cmd>BufferPin<CR>', 'Pin Current Buffer'},
      ['>'] = {'<cmd>BufferMoveNext<CR>', 'Move Buffer Forwards'},
      ['<'] = {'<cmd>BufferMovePrevious<CR>', 'Move Buffer Backwards'},
      ['.'] = {'<cmd>BufferNext<CR>', 'Next Buffer'},
      [','] = {'<cmd>BufferPrevious<CR>', 'Previous Buffer'},
    },
    g = {require("neogit").open, 'Open NeoGit' },
    W = { 'Create dir to current file' },
    ['<leader>'] = {'<cmd>NvimTreeToggle<CR>', 'Toggle NvimTree'},
    e = {'<cmd>NvimTreeFocus<CR>', 'Focus NvimTree'}
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
