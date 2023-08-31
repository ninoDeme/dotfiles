return {
  {
    'neovim/nvim-lspconfig',
    cond = NOT_VSCODE,
    event = "VeryLazy",
    config = function()
      local lspconfig = require('lspconfig')

      -- lsp setup functions {{{
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
            f = { function() vim.lsp.buf.formatting() end, "Format Document" }
          },
        }

        local keymap_g = {
          name = "Goto",
          s = { function() vim.lsp.buf.signature_help() end, "Signature Help" },
          -- d = { function() vim.lsp.buf.definition() end, "View Definition" },
          -- D = { function() vim.lsp.buf.references() end, "View References" },
          -- I = { function() vim.lsp.buf.implementation() end, "Goto Implementation" },
          -- h = { function() vim.lsp.buf.type_definition() end, "View Type Signature" }
          d = { function() require("telescope.builtin").lsp_definitions() end, "View Definition" },
          D = { function() require("telescope.builtin").lsp_references() end, "View References" },
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

        capabilities = require('cmp_nvim_lsp').default_capabilities()
      }
      -- }}}

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

  { 'nvim-lua/lsp-status.nvim', cond = NOT_VSCODE }, -- lsp status
  {
    'linrongbin16/lsp-progress.nvim',
    cond = NOT_VSCODE,
    dependencies = {'nvim-web-devicons'},
    config = function()
      require('lsp-progress').setup()
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
        telescope = vim.tbl_extend("force", require("telescope.themes").get_ivy(),
        { make_value = nil, make_make_display = nil })
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
          null_ls.builtins.code_actions.gitrebase,
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.code_actions.refactoring,
          null_ls.builtins.diagnostics.tsc,
          null_ls.builtins.diagnostics.eslint_d.with(temEslint),
          null_ls.builtins.formatting.eslint_d.with(temEslint),
          null_ls.builtins.code_actions.eslint_d.with(temEslint)
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
        ensure_installed = {
          'lua_ls',
          'tsserver',
          'html',
          'cssls',
          'tailwindcss'
        }
      })
    end
  },
}

-- vim: ts=2 sts=2 sw=2 et
