return {
  -- Autocompletion =======================
  {
    'hrsh7th/nvim-cmp',
    event = "VeryLazy",
    cond = NOT_VSCODE,
    dependencies = {
      {'hrsh7th/cmp-nvim-lsp'}, -- LSP source for nvim-cmp
      {'saadparwaiz1/cmp_luasnip'}, -- Snippets source for nvim-cmp
      {'hrsh7th/cmp-path'},
      {'hrsh7th/cmp-buffer'},
      {'hrsh7th/cmp-cmdline'},
      {'hrsh7th/cmp-nvim-lsp-signature-help'},
      {'ray-x/cmp-treesitter'},
      {'onsails/lspkind.nvim'}
    },
    config = function()
      local cmp = require('cmp')
      local cmp_map = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping.scroll_docs(5),
        ['<C-u>'] = cmp.mapping.scroll_docs(-5),
        ['<C-e>'] = cmp.mapping.scroll_docs(1),
        ['<C-y>'] = cmp.mapping.scroll_docs(-1),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-l>'] = cmp.mapping.confirm(),
      })
      cmp.setup {
        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
            col_offset = -3,
            side_padding = 0,
          }
        },
        snippet = {
          expand = function(args)
           require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = cmp_map,
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'treesitter' },
          { name = 'nvim_lsp_signature_help' }
        },
          { name = 'buffer' }),
        experimental = {
          -- ghost_text = true
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind = require("lspkind").cmp_format({ mode = "text_symbol", maxwidth = 50 })(entry, vim_item)
            local strings = vim.split(kind.kind, "%s", { trimempty = true })
            kind.kind = " " .. (strings[2] or "") .. " "
            kind.menu = "    (" .. (strings[1] or "") .. ")"
            return kind
          end,
        },
      }
      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      -- local misc = require('cmp.utils.misc')
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
            { name = 'cmdline' }
          })
      })
    end
  }
}
