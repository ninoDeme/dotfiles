return {
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    init = function()
      require("which-key").add({
        { '<leader>c', group = "+Code" }
      })
    end,
    config = function()
      -- Lua Language Server Config {{{
      vim.lsp.config('*', {
        -- capabilities = require("cmp_nvim_lsp").default_capabilities({
        --   completionList = {
        --     itemDefaults = {
        --       'commitCharacters',
        --       'editRange',
        --       'insertTextFormat',
        --       'insertTextMode',
        --       'data',
        --     }
        --   }
        -- }),
        capabilities = require('blink.cmp').get_lsp_capabilities()
      })
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              -- library = vim.api.nvim_get_runtime_file("", true),
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                [vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy"] = true,
              },
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      }) -- }}}
      vim.lsp.enable('lua_ls')

      -- vim.lsp.enable('angularls')
      vim.lsp.enable('angularls2')

      vim.lsp.config('html', {
        filetypes = { 'html', 'templ', 'htmlangular', 'vue' }
      })
      vim.lsp.enable('html')

      vim.lsp.enable('cssls')
      vim.lsp.enable('tailwindcss')
      -- vim.lsp.enable('rust_analyzer')
      vim.lsp.enable('pyright')
      vim.lsp.enable('vue_ls')

      vim.lsp.config('vtsls', {
        root_dir = false,
        root_markers = { 'package-lock.json', 'yarn.lock', 'pnpm-lock.yaml', 'bun.lockb', 'bun.lock', 'deno.lock' },
        -- init_options = false,
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  -- location = require("mason-registry").get_package("vue-language-server"):get_install_path() ..
                  location = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server/" ..
                      "/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
                {
                  name = "@angular/language-server",
                  -- location = require("mason-registry").get_package("angular-language-server"):get_install_path() ..
                  location = vim.fn.stdpath("data") .. "/mason/packages/angular-language-server/" ..
                      "/node_modules/@angular/language-server",
                  enableForWorkspaceTypeScriptVersions = false,
                },
              }
            }
          }
        },
        filetypes = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx", "vue", },
      })

      vim.lsp.enable('vtsls')

      -- vim.lsp.config('emmet_language_server', {
      --   { "css", "eruby", "html", "htmldjango", "javascriptreact", "less", "pug", "sass", "scss", "typescriptreact", "htmlangular", "vue" }
      -- })
      -- vim.lsp.enable('emmet_language_server')

      vim.lsp.enable('dartls')
      vim.lsp.enable('clangd')
      vim.lsp.enable('svelte')
      vim.lsp.config('elixirls', {
        cmd = { vim.fn.expand("~/.local/share/elixir-ls/release/language_server.sh") },
      })
      vim.lsp.enable('elixirls')

      vim.lsp.enable('ocamllsp')
    end,
    keys = {
      { mode = { 'n', 'v' }, '<leader>cr', function() vim.lsp.buf.rename() end,                      desc = "Rename" },
      { mode = { 'n', 'v' }, '<leader>ca', function() require("actions-preview").code_actions() end, desc = "Code Actions" },
      { mode = { 'n', 'v' }, '<leader>cA', function() vim.lsp.buf.code_action() end,                 desc = "Code Actions" },
      { mode = { 'n', 'v' }, '<leader>ci', "<cmd>LspInfo<CR>",                                       desc = "Lsp Info" },
      { mode = { 'n', 'v' }, '<leader>cF', function() vim.lsp.buf.format() end,                      desc = "Format Document", },
      { mode = { 'n', 'v' }, '<leader>cd', function() vim.diagnostic.setqflist() end,                desc = "View Diagnostics" },
      {
        mode = { 'n', 'v' },
        '<leader>ce',
        function()
          vim.diagnostic.setqflist({
            severity = vim.diagnostic.severity
                .ERROR
          })
        end,
        desc = "View Errors"
      },
      { mode = { 'n', 'v' }, 'gK',    function() vim.lsp.buf.signature_help() end,                           desc = "Signature Help" },
      { mode = { 'i' },      '<c-k>', function() vim.lsp.buf.signature_help() end,                           desc = "Signature Help" },
      { mode = { 'n', 'v' }, 'gd',    function() vim.lsp.buf.definition() end,                               desc = "View Definition" },
      { mode = { 'n', 'v' }, 'gD',    function() vim.lsp.buf.references({ includeDeclaration = false }) end, desc = "View References" },
      { mode = { 'n', 'v' }, 'gI',    function() vim.lsp.buf.implementation() end,                           desc = "Goto Implementation" },
      { mode = { 'n', 'v' }, 'gh',    function() vim.lsp.buf.type_definition() end,                          desc = "View Type Signature" }
    }
  },
  {
    enabled = false,
    "zeioth/garbage-day.nvim",
    dependencies = "neovim/nvim-lspconfig",
    event = "VeryLazy",
    opts = {
      excluded_lsp_clients = { "null-ls", "jdtls", "marksman", "lua_ls", "roslyn", "rzls" }
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
        telescope = { make_value = nil, make_make_display = nil },
        diff = {
          ignore_whitespace = true,
        },
      })
    end,
    dependencies = { "nvim-telescope/telescope.nvim" },
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
}

-- vim: ts=2 sts=2 sw=2 et
