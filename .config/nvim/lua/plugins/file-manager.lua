return {
  {   -- Nvim-Tree {{{
    'kyazdani42/nvim-tree.lua',
    cond = NOT_VSCODE,
    enabled = false,
    lazy = false,
    config = function()
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

          local function edit_or_open_vertical()
            local node = api.tree.get_node_under_cursor()

            if node.nodes ~= nil then
              -- expand or collapse folder
              api.node.open.vertical()
            else
              -- open file
              api.node.open.vertical()
              -- Close the tree if file was opened
              api.tree.close()
            end
          end
          local function edit_or_open_horizontal()
            local node = api.tree.get_node_under_cursor()

            if node.nodes ~= nil then
              -- expand or collapse folder
              api.node.open.vertical()
            else
              -- open file
              api.node.open.vertical()
              -- Close the tree if file was opened
              api.tree.close()
            end
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

          vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
          vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
          vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
          vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
          vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
          vim.keymap.set('n', 'K', api.node.show_info_popup, opts('Info'))
          vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
          vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
          vim.keymap.set('n', '<C-v>', edit_or_open_vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', '<C-s>', edit_or_open_horizontal, opts('Open: Horizontal Split'))
          vim.keymap.set('n', '.', api.node.run.cmd, opts('Run Command'))
          vim.keymap.set('n', 'y', api.fs.copy.node, opts('Copy'))
          vim.keymap.set('n', 'gY', api.fs.copy.filename, opts('Copy Name'))
          vim.keymap.set('n', 'gy', api.fs.copy.relative_path, opts('Copy Relative Path'))
          vim.keymap.set('n', 'd', api.fs.remove, opts('Delete'))
          vim.keymap.set('n', 'D', api.fs.trash, opts('Trash'))
          vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
          vim.keymap.set('n', 'q', api.tree.close, opts('Close'))
          vim.keymap.set('n', 'r', api.fs.rename, opts('Rename'))
          vim.keymap.set('n', 'R', api.tree.reload, opts('Refresh'))
          vim.keymap.set('n', 's', api.node.run.system, opts('Run System'))
          vim.keymap.set('n', 'S', api.tree.search_node, opts('Search'))
          vim.keymap.set("n", "l", edit_or_open, opts("Edit Or Open"))
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Edit'))
          vim.keymap.set("n", "L", api.node.open.preview, opts("Vsplit Preview"))
          vim.keymap.set("n", "h", api.tree.close, opts("Close"))
          vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
        end
      })
    end,
    keys = {
      {'<leader>.', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle NvimTree'},
      {'<leader>e', '<cmd>NvimTreeFocus<CR>', desc = 'Focus NvimTree'}
    }
  },  -- }}}
  { -- {{{ 
    "tamago324/lir.nvim",
    cond = NOT_VSCODE,
    enabled = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons'
    },
    opts = {
      show_hidden_files = true,
      devicons = {
        enable = true,
      },
      float = {
        curdir_window = {
          enable = true,
        },
        win_opts = function ()
          return  {
            border = "none",
          }
        end,
      },
      mappings = {
        ['l']     = function () require('lir.actions').edit() end,
        ['<C-s>'] = function () require('lir.actions').split() end,
        ['<C-v>'] = function () require('lir.actions').vsplit() end,
        ['<C-t>'] = function () require('lir.actions').tabedit() end,
        ['h']     = function () require('lir.actions').up() end,
        ['q']     = function () require('lir.actions').quit() end,
        ['C']     = function () require('lir.actions').mkdir() end,
        ['c']     = function () require('lir.actions').newfile() end,
        ['r']     = function () require('lir.actions').rename() end,
        ['@']     = function () require('lir.actions').cd() end,
        ['Y']     = function () require('lir.actions').yank_path() end,
        ['.']     = function () require('lir.actions').toggle_show_hidden() end,
        ['d']     = function () require('lir.actions').delete() end,

        ['J'] = function()
          require('lir.mark.actions').toggle_mark()
          vim.cmd('normal! j')
        end,
        ['y'] = function () require('lir.clipboard.actions').copy() end,
        ['x'] = function () require('lir.clipboard.actions').cut() end,
        ['p'] = function () require('lir.clipboard.actions').paste() end,
      },
    },
    lazy = false,
    keys = {
      {'<leader>.', function() require('lir.float').toggle() end, desc = "Find File"},
      {"<leader>e", "<cmd>edit .<CR>", desc = "Open File Browser"}
    }
  }, -- }}}
  {
    "theblob42/drex.nvim",
    cond = NOT_VSCODE,
    enabled = false,
    lazy = false,
    config = function() 
      require("drex.config").configure({
        hijack_netrw = true,
      })
    end,
    dependencies = {
      "kyazdani42/nvim-web-devicons"
    },
    keys = {
      {'<leader>.', "<cmd>DrexDrawerOpen<CR>", desc = "Find File"},
      {"<leader>e", "<cmd>Drex<CR>", desc = "Open File Browser"}
    }
  },
  {
    'luukvbaal/nnn.nvim',
    cond = NOT_VSCODE,
    -- enabled = false,
    lazy = false,
    config = function ()
      require("nnn").setup({
        replace_netrw = "picker",
        picker = {
          cmd = "nnn -doC",
        },
      })
    end,
    keys = {
      {'<leader>.', "<cmd>NnnPicker %:p:h<CR>", desc = "Find File"},
      {"<leader>e", "<cmd>NnnPicker<CR>", desc = "Open File Browser"}
    }
  }
}
