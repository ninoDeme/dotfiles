return {
  {
    "seblyng/roslyn.nvim",
    ft = { "cs", "razor" },
    dependencies = {
      {
        -- By loading as a dependencies, we ensure that we are available to set
        -- the handlers for Roslyn.
        "tris203/rzls.nvim",
        config = true,
      },
    },
    config = function()
      -- Use one of the methods in the Integration section to compose the command.
      local mason_registry = require("mason-registry")

      ---@type string[]
      local cmd = {}

      local roslyn_package = mason_registry.get_package("roslyn")
      -- if roslyn_package:is_installed() then
      --   vim.list_extend(cmd, {
      --     "roslyn",
      --     "--stdio",
      --     "--logLevel=Information",
      --     "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
      --   })
      --
      --   local rzls_package = mason_registry.get_package("rzls")
      --   if rzls_package:is_installed() then
      --     local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      --     table.insert(
      --       cmd,
      --       "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll")
      --     )
      --     table.insert(
      --       cmd,
      --       "--razorDesignTimePath="
      --       .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets")
      --     )
      --     vim.list_extend(cmd, {
      --       "--extension",
      --       vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      --     })
      --   end
      -- end
      --
      -- require("roslyn").setup {
      --   cmd = cmd,
      --   config = {
      --     handlers = require("rzls.roslyn_handlers"),
      --   },
      --   broad_search = false,
      -- }
      --
      require("roslyn").setup {
        broad_search = true,
        filewatching = "roslyn",
      }
    end,
    init = function()
      -- We add the Razor file types before the plugin loads.
      vim.filetype.add({
        extension = {
          razor = "razor",
          cshtml = "razor",
        },
      })
    end,
  },
}
