return {
  {
    'nvim-treesitter/nvim-treesitter', cond = NOT_VSCODE,
    lazy = true,
    event = 'VeryLazy',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
        },
        rainbow = {
          enable = false
        },
        indent = {
          enable = true,
          disable = { 'dart' }
        },
        autotag = {
          enable = NOT_VSCODE()
        },

        ensure_installed = { 'typescript', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'json', 'jsdoc', 'javascript', 'sql', 'vim', 'vimdoc', 'html', 'css', 'scss'}
      }

      require 'treesitter-context'.setup { enable = true, throttle = true, }

      -- if vim.uv.os_uname().sysname == "Windows_NT" then
      --    require('nvim-treesitter.install').compilers = { "clang" }
      -- end
      --
      -- require 'nvim-treesitter.install'.prefer_git = false
    end,
    dependencies = {
      'romgrk/nvim-treesitter-context',
      'p00f/nvim-ts-rainbow',
      "windwp/nvim-ts-autotag",
    }
  }, -- Parsesr and highlighter for a lot of languages
  {
    'romgrk/nvim-treesitter-context', -- Shows the context (current function or method)
    dependencies = 'nvim-treesitter',
    cond = NOT_VSCODE
  },
  {
    'p00f/nvim-ts-rainbow',
    cond = NOT_VSCODE
  },
  {
    "windwp/nvim-ts-autotag",
    cond = NOT_VSCODE
  },
}

