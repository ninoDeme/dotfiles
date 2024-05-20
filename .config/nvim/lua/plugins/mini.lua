return {
  {
    "echasnovski/mini.nvim",
    event = "VeryLazy",
    config = function()
      if NOT_VSCODE() then
        require("mini.files").setup()

        require("mini.surround").setup({
          mappings = {
            add = "gsa", -- Add surrounding in Normal and Visual modes
            delete = "gsd", -- Delete surrounding
            find = "gsf", -- Find surrounding (to the right)
            find_left = "gsF", -- Find surrounding (to the left)
            highlight = "gsh", -- Highlight surrounding
            replace = "gsr", -- Replace surrounding
            update_n_lines = "gsn", -- Update `n_lines`

            suffix_last = "l", -- Suffix to search with "prev" method
            suffix_next = "n", -- Suffix to search with "next" method
          },
        })

        -- require('mini.cursorword').setup()
        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
          highlighters = {
            -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
            fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
            hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
            todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
            note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
          },
        })
      end
      require("mini.bracketed").setup()

      -- local spec_treesitter = require("mini.ai").gen_spec.treesitter
      -- require("mini.ai").setup({
      --   -- Number of lines within which textobject is searched
      --   n_lines = 10000,
      --   custom_textobjects = {
      --     g = function()
      --       local from = { line = 1, col = 1 }
      --       local to = {
      --         line = vim.fn.line("$"),
      --         col = math.max(vim.fn.getline("$"):len(), 1),
      --       }
      --       return { from = from, to = to }
      --     end,
      --     -- T = spec_treesitter({ a = "@tag_name", i = "@tag_name" }),
      --     -- t = spec_treesitter({ a = "@tag.outer", i = "@tag.inner" }),
      --     -- x = spec_treesitter({ a = "@attribute.outer", i = "@attribute.inner" }),
      --     x = {
      --     	{
          		-- '%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b""()',
      --     		"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b''()",
      --     		"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=%b{}()",
      --     		"%s()%[?%(?[%w_%.#%*%-@:]+%)?%]?=[%w_-]+()",
      --     	},
      --     },
      --   },
      -- })
      require("mini.align").setup()
      require("mini.splitjoin").setup()
      require("mini.operators").setup({
        exchange = {
          prefix = "cx",
        },
      })
    end,
    keys = {
      { mode = "n", "gR", "gr$", remap = true },
      { mode = "n", "cX", "cx$", remap = true },
      { "<leader>m", desc = "+Mini" },
      {
        "<leader>me",
        function()
          require("mini.files").open()
        end,
        desc = "Open Mini Files",
      },
      {
        "<leader>m.",
        function()
          require("mini.files").open(vim.fn.expand("%:p:h"))
        end,
        desc = "Open Mini Files at dir",
      },
      { "gs", desc = "+Surrounding" },
      { mode = { "n", "v" }, "gsa", desc = "Add surrounding" },
      { mode = "n", "gsd", desc = "Delete surrounding" },
      { mode = "n", "gsf", desc = "Find surrounding (to the right)" },
      { mode = "n", "gsF", desc = "Find surrounding (to the left)" },
      { mode = "n", "gsh", desc = "Highlight surrounding" },
      { mode = "n", "gsr", desc = "Replace surrounding" },
      { mode = "n", "gsn", desc = "Update `n_lines`" },
    },
  },
}
