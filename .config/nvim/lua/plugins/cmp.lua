return {
  -- Autocompletion =======================
  {
    enabled = true,
    'saghen/blink.cmp',
    lazy = false, -- lazy loading handled internally
    -- optional: provides snippets for the snippet source
    dependencies = { 'rafamadriz/friendly-snippets', "alexandre-abrioux/blink-cmp-npm.nvim", },

    -- use a release tag to download pre-built binaries
    version = '1.*',
    -- OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

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
        menu = {
          auto_show = function(ctx) return ctx.mode ~= 'cmdline' end
        },
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
      },
      fuzzy = { implementation = "prefer_rust_with_warning" },

      sources = {
        default = {
          'npm',
          'lsp',
          'snippets',
          'path',
          'buffer'
        },
        providers = {
          -- defaults to `{ 'buffer' }`
          lsp = { fallbacks = {} },
          -- configure the provider
          npm = {
            name = "npm",
            module = "blink-cmp-npm",
            async = true,
            -- optional - make blink-cmp-npm completions top priority (see `:h blink.cmp`)
            score_offset = 100,
            -- fallbacks = { 'buffer' }
          },
        }
      },
    },
    -- allows extending the enabled_providers array elsewhere in your config
    -- without having to redefining it
    opts_extend = { "sources.completion.enabled_providers" },
  },
}
