return {
  {
    'nvim-treesitter/nvim-treesitter', cond = NOT_VSCODE,
    lazy = true,
    event = 'VeryLazy',
    config = function()
      -- TreeSitter {{{
      require 'nvim-treesitter.configs'.setup {
        highlight = {
          enable = true,
          --[[ disable = {
        -- 'typescript',
        'javascript',
        'html',
        'lua'
      } ]]
        },
        rainbow = {
          enable = true
        },
        indent = {
          enable = true,
        },
        autotag = {
          enable = true
        },
        ensure_installed = { 'typescript', 'lua'}
      }

      require 'treesitter-context'.setup { enable = true, throttle = true, }

      require 'nvim-treesitter.install'.compilers = { "clang", "gcc" }
      require 'nvim-treesitter.install'.prefer_git = false

      -- }}}
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
  {'p00f/nvim-ts-rainbow', cond = NOT_VSCODE},

  {
    "windwp/nvim-ts-autotag",
    cond = NOT_VSCODE
  },
}

