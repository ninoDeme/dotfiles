return {
  {
    'kyazdani42/nvim-tree.lua',
    cond = NOT_VSCODE,
    lazy = false,
    config = function()
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

          vim.keymap.set('n', 'x', api.fs.cut, opts('Cut'))
          vim.keymap.set('n', 'p', api.fs.paste, opts('Paste'))
          vim.keymap.set('n', 'c', api.fs.create, opts('Create'))
          vim.keymap.set('n', '<C-]>', api.tree.change_root_to_node, opts('CD'))
          vim.keymap.set('n', '<C-e>', api.node.open.replace_tree_buffer, opts('Open: In Place'))
          vim.keymap.set('n', 'K', api.node.show_info_popup, opts('Info'))
          vim.keymap.set('n', '<C-r>', api.fs.rename_sub, opts('Rename: Omit Filename'))
          vim.keymap.set('n', '<C-t>', api.node.open.tab, opts('Open: New Tab'))
          vim.keymap.set('n', '<C-v>', api.node.open.vertical, opts('Open: Vertical Split'))
          vim.keymap.set('n', '<C-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
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
          vim.keymap.set("n", "l", api.node.open.edit, opts("Edit Or Open"))
          vim.keymap.set('n', '<CR>', api.node.open.edit, opts('Edit'))
          vim.keymap.set("n", "L", api.node.open.preview, opts("Vsplit Preview"))
          vim.keymap.set("n", "h", api.tree.close, opts("Close"))
          vim.keymap.set("n", "H", api.tree.collapse_all, opts("Collapse All"))
        end
      })
      -- }}}
    end,
    keys = {
      {'<leader><leader>', '<cmd>NvimTreeToggle<CR>', desc = 'Toggle NvimTree'},
      {'<leader>e', '<cmd>NvimTreeFocus<CR>', desc = 'Focus NvimTree'}
    }
  }
}
