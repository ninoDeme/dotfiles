local function get_roslyn_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require('blink.cmp').get_lsp_capabilities()

  capabilities.textDocument = capabilities.textDocument or {}
  capabilities.textDocument.diagnostic = capabilities.textDocument.diagnostic or {}
  capabilities.textDocument.diagnostic.dynamicRegistration = true

  capabilities.workspace = capabilities.workspace or {}
  capabilities.workspace.didChangeWatchedFiles = capabilities.workspace.didChangeWatchedFiles or {}
  capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

  return capabilities
end

return {
  {
    enabled = true,
    -- cond = false,
    "tris203/roslyn.nvim",
    -- branch = "cohosting",
    ft = { "cs", "razor", "cshtml" },
    -- dependencies = {
    --   {
    --     -- By loading as a dependencies, we ensure that we are available to set
    --     -- the handlers for Roslyn.
    --     "tris203/rzls.nvim",
    --     config = true,
    --   },
    -- },
    dependencies = { "nvim-lspconfig" },
    config = function()
      -- local rzls_path = vim.fn.expand("$MASON/packages/rzls/libexec")
      -- local cmd = {
      --   "roslyn",
      --   "--stdio",
      --   "--logLevel=Information",
      --   "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.log.get_filename()),
      --   "--razorSourceGenerator=" .. vim.fs.joinpath(rzls_path, "Microsoft.CodeAnalysis.Razor.Compiler.dll"),
      --   "--razorDesignTimePath=" .. vim.fs.joinpath(rzls_path, "Targets", "Microsoft.NET.Sdk.Razor.DesignTime.targets"),
      --   "--extension",
      --   vim.fs.joinpath(rzls_path, "RazorExtension", "Microsoft.VisualStudioCode.RazorExtension.dll"),
      -- }
      -- require("roslyn").setup {
      --   broad_search = true,
      --   filewatching = "roslyn",
      -- }
      -- vim.lsp.config("roslyn", {
      --   cmd = cmd,
      --   handlers = require("rzls.roslyn_handlers"),
      -- })
      vim.lsp.enable('roslyn')
      vim.lsp.config('roslyn', {
        capabilities = get_roslyn_capabilities()
      })
    end,
    opts = {
      -- "auto" | "roslyn" | "off"
      --
      -- - "auto": Does nothing for filewatching, leaving everything as default
      -- - "roslyn": Turns off neovim filewatching which will make roslyn do the filewatching
      -- - "off": Hack to turn off all filewatching. (Can be used if you notice performance issues)
      filewatching = "roslyn",


      -- If the plugin should silence notifications about initialization
      -- silent = false,
    },
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
