return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    dev = true,
    event = "VeryLazy",
    config = function()
      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
      parser_config.angular.install_info.url = "~/Projects/tree-sitter-angular/"
      -- parser_config.angular.install_info.revision = "9353df6189cd174848d873d7e4ebc3c7caec4ddb"
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
        },
        indent = {
          enable = true,
          disable = { "dart" },
        },
        ensure_installed = {
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
        },
      })

      -- require("treesitter-context").setup({ enable = true, throttle = true })

      -- if vim.uv.os_uname().sysname == "Windows_NT" then
      --    require('nvim-treesitter.install').compilers = { "clang" }
      -- end
      --
      -- require 'nvim-treesitter.install'.prefer_git = false
    end,
    dependencies = {
      {
        "romgrk/nvim-treesitter-context", -- Shows the context (current function or method)
        dependencies = "nvim-treesitter",
      },
      "windwp/nvim-ts-autotag",
      {
        "LiadOz/nvim-dap-repl-highlights",
        opts = {},
      },
    },
  }, -- Parsesr and highlighter for a lot of languages
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
        }
      })
    end,
    lazy = false,
  },
}
