return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    dev = true,
    event = "VeryLazy",
    build = ':TSUpdate',
    branch = 'main',
    config = function()
      -- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      -- parser_config.angular.install_info.url = "~/Projects/tree-sitter-angular/"
      -- parser_config.angular.install_info.revision = "9353df6189cd174848d873d7e4ebc3c7caec4ddb"

      vim.api.nvim_create_autocmd('FileType', {
        pattern = { '*' },
        callback = function()
          local installed = require('nvim-treesitter').get_installed('parsers')
          local parser = vim.treesitter.language.get_lang(vim.bo.ft)
          for _, lang in ipairs(installed) do
            if lang == parser then
              vim.treesitter.start()
              break
            end
          end
        end,
      })

      require('nvim-treesitter').install({
        "typescript",
        "lua",
        "luadoc",
        "markdown",
        "markdown_inline",
        "json",
        "jsdoc",
        "javascript",
        "sql",
        "vim",
        "vimdoc",
        "html",
        "css",
        "scss",
        "angular",
        "dap_repl",
      })
    end,
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-context", -- Shows the context (current function or method)
        dependencies = "nvim-treesitter",
      },
      "windwp/nvim-ts-autotag",
      {
        "LiadOz/nvim-dap-repl-highlights",
        opts = {},
      },
    },
  },
  {
    "windwp/nvim-ts-autotag",
    config = function(_)
      require('nvim-ts-autotag').setup({
        opts = {
          enable_rename = true,
          enable_close = true,
          enable_close_on_slash = false,
        },
        aliases = {
          ["htmlangular"] = "html",
          ["angular"] = "html",
          ["heex"] = "html",
          ["razor"] = "html",
        }
      })
    end,
    lazy = false,
  },
}
