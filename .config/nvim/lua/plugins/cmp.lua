return {
  -- Autocompletion =======================
  {
    enabled = false,
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    version = false,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp" }, -- LSP source for nvim-cmp
      -- {'saadparwaiz1/cmp_luasnip'}, -- Snippets source for nvim-cmp
      {
        -- enabled = false,
        "garymjr/nvim-snippets",
        event = "VeryLazy",
        dependencies = { "rafamadriz/friendly-snippets" },
        opts = {
          friendly_snippets = true,
        },
        keys = {
          {
            "<Tab>",
            function()
              if vim.snippet.active({ direction = 1 }) then
                vim.schedule(function()
                  vim.snippet.jump(1)
                end)
                return
              end
              return "<Tab>"
            end,

            expr = true,
            silent = true,
            mode = { "i", "s" },
          },
          {
            "<S-Tab>",
            function()
              if vim.snippet.active({ direction = -1 }) then
                vim.schedule(function()
                  vim.snippet.jump(-1)
                end)
                return
              end
              return "<S-Tab>"
            end,
            expr = true,
            silent = true,
            mode = { "i", "s" },
          },
        },
      },
      { "hrsh7th/cmp-path" },
      { "hrsh7th/cmp-buffer" },
      -- {'hrsh7th/cmp-cmdline'},
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "hrsh7th/cmp-nvim-lsp-document-symbol" },
      { "ray-x/cmp-treesitter" },
      { "onsails/lspkind.nvim" },
    },
    config = function()
      local cmp = require("cmp")
      local cmp_map = cmp.mapping.preset.insert({
        ["<C-d>"] = cmp.mapping.scroll_docs(5),
        ["<C-u>"] = cmp.mapping.scroll_docs(-5),
        ["<C-e>"] = cmp.mapping.scroll_docs(1),
        ["<C-y>"] = cmp.mapping.scroll_docs(-1),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-l>"] = cmp.mapping.confirm({ select = true }),
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      })
      cmp.setup({
        window = {
          completion = {
            -- border = require("hover").border,
            border = { "", "", "", "", "", "", "", "", },
            -- winhighlight = "Normal:FloatNormal",
          },
          documentation = {
            winhighlight = "Normal:FloatNormal",
            border = require("hover").alt_border,
          },
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        mapping = cmp_map,
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "nvim_lsp_signature_help", priority = 100 },
          { name = "nvim_lsp",                priority = 10 },
          { name = "snippets",                priority = 0,  keyword_length = 3 },
        }, {
          { name = "treesitter" },
          { name = "buffer" },
        }),
        experimental = {
          ghost_text = false,
        },
        formatting = {
          format = function(entry, item)
            local color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
            item = require("lspkind").cmp_format({
              mode = "text_symbol",
              maxwidth = 60,
            })(entry, item)
            if color_item.abbr_hl_group then
              item.kind_hl_group = color_item.abbr_hl_group
              item.kind = "Color " .. color_item.abbr
            end
            return item
          end
        },
      })
      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline({ '/', '?' }, {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = {
      --     {
      --       { name = 'nvim_lsp_document_symbol' }
      --     },
      --     {
      --       { name = 'buffer' },
      --       { name = 'treesitter'},
      --     }
      --   }
      -- })
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- cmp.setup.cmdline(':', {
      --   mapping = cmp.mapping.preset.cmdline(),
      --   sources = cmp.config.sources(
      --     {
      --       { name = 'path' }
      --     },
      --     {
      --       { name = 'cmdline' }
      --     }
      --   )
      -- })
    end,
  },
  {
    enabled = true,
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = 'v0.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = 'default',
      },

      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = true,

        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = 'normal',
      },

      -- experimental auto-brackets support
      -- accept = { auto_brackets = { enabled = true } }

      -- experimental signature help support
      signature = { enabled = true },
      completion = {
        menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end },
        documentation = {
          auto_show_delay_ms = 100,
          auto_show = true,
          window = {
            border = require("hover").border,
          }
        }
      },
      cmdline = {
        enabled = false
      }
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" }
  },
}
