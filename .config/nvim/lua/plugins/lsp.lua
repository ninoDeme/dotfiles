-- lsp setup functions {{{
--
local border = {
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
  {" ", "FloatBorder"},
}

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = border, silent = true}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = border , silent = true}),
}

local function keymappings(client, bufnr)
  local opts = { noremap = true, silent = true }

  -- lsp Key mappings
  vim.keymap.set("n", "[d", function() vim.diagnostic.goto_prev() end, opts)
  vim.keymap.set("n", "]d", function() vim.diagnostic.goto_next() end, opts)
  vim.keymap.set("n", "[e", function() vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR}) end,
    opts)
  vim.keymap.set("n", "]e", function() vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR}) end,
    opts)

  -- Whichkey
  local keymap_l = {
    l = {
      name = "Code",
      r = { function() vim.lsp.buf.rename() end, "Rename" },
      a = { function() require("actions-preview").code_actions() end, 'Code Actions'},
      -- a = { function() vim.lsp.buf.code_action() end, "Code Action" },
      i = { "<cmd>LspInfo<CR>", "Lsp Info" },
      f = { function() vim.lsp.buf.format() end, "Format Document" }
    },
  }

  local keymap_g = {
    name = "Goto",
    s = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
    -- d = { function() vim.lsp.buf.definition() end, "View Definition" },
    -- D = { function() vim.lsp.buf.references() end, "View References" },
    -- I = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
    -- h = { function() vim.lsp.buf.type_definition() end, "View Type Signature" }
    d = { function() require("telescope.builtin").lsp_definitions({show_line = false}) end, "View Definition" },
    D = { function() require("telescope.builtin").lsp_references({show_line = false}) end, "View References" },
    I = { function() require("telescope.builtin").lsp_implementations() end, "Goto Implementation" },
    h = { function() require("telescope.builtin").lsp_type_definitions() end, "View Type Signature" }
  }
  local whichkey = require('which-key')
  whichkey.register(keymap_l, { buffer = bufnr, prefix = "<leader>", mode = {'n', 'v'}})
  whichkey.register(keymap_g, { buffer = bufnr, prefix = "g" })
  whichkey.register({K = { function() vim.lsp.buf.hover() end, "View Hover" }}, { buffer = bufnr })
end

local lsp_opts = {
  on_attach = function(client, bufnr)
    -- Use LSP as the handler for formatexpr.
    -- See `:help formatexpr` for more information. 'gq'
    vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

    -- Configure key mappings
    keymappings(client, bufnr)
  end,

  handlers = handlers,
  capabilities = require('cmp_nvim_lsp').default_capabilities()
}
-- }}}

return {
  {
    'neovim/nvim-lspconfig',
    cond = NOT_VSCODE,
    event = "VeryLazy",
    config = function()
      local lspconfig = require('lspconfig')


      -- Lua Language Server Config {{{
      lspconfig.lua_ls.setup {
        settings = {
          Lua = {
            runtime = {
              -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT',
            },
            diagnostics = {
              -- Get the language server to recognize the `vim` global
              globals = { 'vim' },
            },
            workspace = {
              -- Make the server aware of Neovim runtime files
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
              enable = false,
            },
          },
        },
        handlers = handlers,
        on_attach = lsp_opts.on_attach,
        capabilities = lsp_opts.capabilities
      } -- }}}

      lspconfig.angularls.setup(lsp_opts)
      lspconfig.html.setup(lsp_opts)
      lspconfig.cssls.setup(lsp_opts)
      lspconfig.tailwindcss.setup(lsp_opts)
      lspconfig.tsserver.setup(lsp_opts)

      local signs = { Error = "", Warn = "", Hint = "", Info = "" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end
  },

  {
    'onsails/lspkind.nvim',
    config = function ()
      require('lspkind').init({
        preset = "codicons"
      })
    end,
    cond = NOT_VSCODE
  },

  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" }
    },
    config = true,
    opts = {},
    event = "VeryLazy",
    cond = NOT_VSCODE
  },

  {
    "aznhe21/actions-preview.nvim",
    config = function()
      require("actions-preview").setup {
        telescope = { make_value = nil, make_make_display = nil, layout_strategy = "bottom_pane" }
      }
    end,
    dependencies = { 'nvim-telescope/telescope.nvim' },
    keys = {
      { "<leader>la", desc = 'Code Actions', mode = { "v", "n" } }
    },
    cond = NOT_VSCODE
  },

  {
    'jose-elias-alvarez/null-ls.nvim',
    event = "VeryLazy",
    dependencies = "ThePrimeagen/refactoring.nvim",
    config = function ()
      local temEslint = {
        condition = function(utils)
          return utils.root_has_file({".eslintrc.json", ".eslintrc.js"})
        end,
      }
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.diagnostics.tsc,
          null_ls.builtins.diagnostics.eslint_d.with(temEslint),
          null_ls.builtins.formatting.eslint_d.with(temEslint),
          null_ls.builtins.code_actions.eslint_d.with(temEslint),
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.code_actions.gitsigns,
        }
      })
    end,
    cond = NOT_VSCODE
  },

  {
    'jay-babu/mason-null-ls.nvim',
    config = function()
      require("mason-null-ls").setup({
        ensure_installed = {
          'eslint_d',
        },
        automatic_installation = false,
        automatic_setup = false, -- Recommended, but optional
      })
    end,
    lazy = true,
    event = "VeryLazy",
    dependencies = { 'williamboman/mason.nvim' },
    cond = NOT_VSCODE
  },

  {
    'williamboman/mason-lspconfig.nvim',
    cond = NOT_VSCODE,
    lazy = true,
    event = "VeryLazy",
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
    end
  },

  {
    'mfussenegger/nvim-jdtls',
    event = "VeryLazy",
    dependencies = {
      'mason.nvim',
      'nvim-dap',
    },
    config = function()

      local function setup_server()
        local java_opts = vim.tbl_extend("force", lsp_opts, {
          cmd = { vim.fn.stdpath('data') .. '/mason/bin/jdtls'},
          root_dir = vim.fs.dirname(vim.fs.find({'gradlew', '.git', 'mvnw', 'pom.xml'}, { upward = true })[1]),
          init_options = {
            bundles = {
              vim.fn.glob( vim.fn.stdpath('data') .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
            };
          }
        })
        require('jdtls').start_or_attach(java_opts)
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "java",
        callback = function()

          local mason_reg = require("mason-registry")
          if not mason_reg.is_installed("jdtls") then
            if vim.fn.confirm("Download Language Server (jdtls)?", "&Yes\n&No", 1) == 1 then
              local pkg = mason_reg.get_package("jdtls")

              vim.notify("Installing jdtls", nil, {title = "Mason Install"})
              pkg:install()

              pkg:on("install:success", vim.schedule_wrap(function()
                vim.notify("[mason.nvim] jdtls was successfully installed")
                setup_server()
              end))
              pkg:on("install:failed", vim.schedule_wrap(function()
                vim.notify( "[mason.nvim] failed to install jdtls. Installation logs are available in :Mason and :MasonLog", vim.log.levels.ERROR)
              end))
            end
          else
            setup_server()
          end
        end
      })
    end
  }
  -- {
  --   'mrded/nvim-lsp-notify',
  --   config = function()
  --     require('lsp-notify').setup({})
  --   end,
  --   event = "VeryLazy"
  -- }
}

-- vim: ts=2 sts=2 sw=2 et
