-- lsp setup functions {{{

local lsp_opts = {
  capabilities = require("cmp_nvim_lsp").default_capabilities({
    completionList = {
      itemDefaults = {
        'commitCharacters',
        'editRange',
        'insertTextFormat',
        'insertTextMode',
        'data',
      }
    }
  }),
  on_attach = function(client, bufnr)
  end,
}
-- }}}

return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    init = function()
      local border = require("hover").border
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = border,
        silent = true,
      })
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = border,
        focusable = true,
        zindex = 1005,
        relative = "cursor",
        silent = true,
      })
      require("which-key").add({
        { '<leader>c', group = "+Code" }
      })
    end,
    config = function()
      local lspconfig = require("lspconfig")

      -- Borders for LspInfo winodw
      local win = require("lspconfig.ui.windows")
      local _default_opts = win.default_opts

      local border = require("hover").border

      win.default_opts = function(options)
        local opts = _default_opts(options)
        opts.border = border
        return opts
      end

      -- local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Lua Language Server Config {{{
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = "LuaJIT",
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { "vim" },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              -- library = vim.api.nvim_get_runtime_file("", true),
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
              },
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
        on_attach = lsp_opts.on_attach,
        capabilities = lsp_opts.capabilities,
      }) -- }}}

      lspconfig.angularls.setup(lsp_opts)
      lspconfig.html.setup(vim.tbl_extend("force", lsp_opts, {
        filetypes = { 'html', 'templ', 'htmlangular' }
      }))
      lspconfig.cssls.setup(lsp_opts)
      -- require("lspconfig.configs").firebird_ls = {
      --   default_config = {
      --     cmd = { 'node', '/home/ricardo/Projects/firebird-language-server/build/language-server.js', '--stdio' },
      --
      --     filetypes = { 'sql' },
      --     single_file_support = true,
      --     settings = { sql = {} },
      --   },
      -- }
      -- lspconfig.firebird_ls.setup(lsp_opts);
      lspconfig.tailwindcss.setup(lsp_opts)
      -- lspconfig.rust_analyzer.setup(lsp_opts)
      lspconfig.pyright.setup(lsp_opts)
      lspconfig.volar.setup(lsp_opts)
      lspconfig.vtsls.setup(vim.tbl_extend("force", lsp_opts, {
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = require("mason-registry").get_package("vue-language-server"):get_install_path() .. "/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              }
            }
          }
        },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", },
      }))
      lspconfig.emmet_language_server.setup(lsp_opts)

      lspconfig.dartls.setup(lsp_opts)
      lspconfig.clangd.setup(lsp_opts)
      lspconfig.svelte.setup(lsp_opts)
      lspconfig.elixirls.setup(vim.tbl_extend("force", lsp_opts, {
        cmd = { vim.fn.expand("~/.local/share/elixir-ls/release/language_server.sh") },
      }))

      lspconfig.ocamllsp.setup(lsp_opts)
    end,
    keys = {
      { mode = { 'n', 'v' }, '<leader>cr', function() vim.lsp.buf.rename() end,                                                   desc = "Rename" },
      { mode = { 'n', 'v' }, '<leader>ca', function() require("actions-preview").code_actions() end,                              desc = "Code Actions" },
      { mode = { 'n', 'v' }, '<leader>cA', function() vim.lsp.buf.code_action() end,                                              desc = "Code Actions" },
      { mode = { 'n', 'v' }, '<leader>ci', "<cmd>LspInfo<CR>",                                                                    desc = "Lsp Info" },
      { mode = { 'n', 'v' }, '<leader>cF', function() vim.lsp.buf.format() end,                                                   desc = "Format Document", },
      { mode = { 'n', 'v' }, '<leader>cd', function() vim.diagnostic.setqflist() end,                                             desc = "View Diagnostics" },
      { mode = { 'n', 'v' }, '<leader>ce', function() vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR }) end, desc = "View Errors" },

      { mode = { 'n', 'v' }, 'gK',         function() vim.lsp.buf.signature_help() end,                                           desc = "Signature Help" },
      { mode = { 'i' },      '<c-k>',      function() vim.lsp.buf.signature_help() end,                                           desc = "Signature Help" },
      { mode = { 'n', 'v' }, 'gd',         function() vim.lsp.buf.definition() end,                                               desc = "View Definition" },
      { mode = { 'n', 'v' }, 'gD',         function() vim.lsp.buf.references({ includeDeclaration = false }) end,                 desc = "View References" },
      { mode = { 'n', 'v' }, 'gI',         function() vim.lsp.buf.implementation() end,                                           desc = "Goto Implementation" },
      { mode = { 'n', 'v' }, 'gh',         function() vim.lsp.buf.type_definition() end,                                          desc = "View Type Signature" }
    }
  },

  {
    "onsails/lspkind.nvim",
    config = function()
      require("lspkind").init({
        preset = "codicons",
      })
    end,
  },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup({
        telescope = { make_value = nil, make_make_display = nil},
        diff = {
          ignore_whitespace = true,
        },
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({})
    end,
  },

  -- {
  --   "mfussenegger/nvim-jdtls",
  --   event = "VeryLazy",
  --   dependencies = {
  --     "mason.nvim",
  --     "nvim-dap",
  --   },
  --   config = function()
  --     local function setup_server()
  --       local java_opts = vim.tbl_extend("force", lsp_opts, {
  --         cmd = { vim.fn.stdpath("data") .. "/mason/bin/jdtls" },
  --         root_dir = vim.fs.dirname(
  --           vim.fs.find({ "gradlew", ".git", "mvnw", "pom.xml" }, { upward = true })[1]
  --         ),
  --         init_options = {
  --           bundles = {
  --             vim.fn.glob(
  --               vim.fn.stdpath("data") ..
  --               "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
  --               true
  --             ),
  --           },
  --         },
  --       })
  --       require("jdtls").start_or_attach(java_opts)
  --     end
  --
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = "java",
  --       callback = function()
  --         local mason_reg = require("mason-registry")
  --         if not mason_reg.is_installed("jdtls") then
  --           if vim.fn.confirm("Download Language Server (jdtls)?", "&Yes\n&No", 1) == 1 then
  --             local pkg = mason_reg.get_package("jdtls")
  --
  --             vim.notify("Installing jdtls", nil, { title = "Mason Install" })
  --             pkg:install()
  --
  --             pkg:on(
  --               "install:success",
  --               vim.schedule_wrap(function()
  --                 vim.notify("[mason.nvim] jdtls was successfully installed")
  --                 setup_server()
  --               end)
  --             )
  --             pkg:on(
  --               "install:failed",
  --               vim.schedule_wrap(function()
  --                 vim.notify(
  --                   "[mason.nvim] failed to install jdtls. Installation logs are available in :Mason and :MasonLog",
  --                   vim.log.levels.ERROR
  --                 )
  --               end)
  --             )
  --           end
  --         else
  --           setup_server()
  --         end
  --       end,
  --     })
  --   end,
  -- },
  -- {
  --   'mrded/nvim-lsp-notify',
  --   config = function()
  --     require('lsp-notify').setup({})
  --   end,
  --   event = "VeryLazy"
  -- }
}

-- vim: ts=2 sts=2 sw=2 et
