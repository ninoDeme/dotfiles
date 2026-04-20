return {
  {
    'nanotech/jellybeans.vim',
    lazy = false,
    priority = 500
  },
  {
    'srcery-colors/srcery-vim',
    lazy = false,
    priority = 500
  },
  {
    'sjl/badwolf',
    lazy = false,
    priority = 500
  },
  {
    'rose-pine/neovim',
    lazy = false,
    priority = 500
  },
  {
    'mathofprimes/nightvision-nvim',
    lazy = false,
    priority = 500
  },
  {
    'Shatur/neovim-ayu',
    lazy = false,
    priority = 500,
    config = false
  },
  {
    'oskarnurm/koda.nvim',
    lazy = false,
    priority = 500
  },
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 500,
    config = function()
      local variants = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' }
      require('onedark').setup({
        style = variants[math.random(#variants)],

        toggle_style_key = '<leader>ts',
        toggle_style_list = variants
      })
    end
  },
  {
    'gbprod/nord.nvim',
    lazy = false,
    priority = 500,
  },
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 500
  },
  {
    "Mofiqul/adwaita.nvim",
    lazy = false,
    priority = 500,
  },
  {
    "base46",
    lazy = true,
    keys = {
      vim.keymap.set("n", "<leader>tn", function()
        local templates = require('base46').list_themes()
        local items = {}

        for idx, tmpl in ipairs(templates) do
          local item = {
            idx = idx,
            name = tmpl,
            text = tmpl,
            action = tmpl,
            preview = {
              text = tmpl,
            }
          }
          table.insert(items, item)
        end
        Snacks.picker({
          title = "Task Template",
          items = items,
          layout = {
            preset = "default",
            -- preview = false,
          },
          preview = "preview",
          format = function(item, _)
            return { { item.text, item.text_hl } }
          end,
          confirm = function(picker, item)
            return picker:norm(
              function()
                require('base46').apply_theme(item.action)
                picker:close()
              end
            )
          end,
        })
      end, { desc = "Theme Run" })
    },
    dev = true
  },
  {
    "rockerBOO/boo-colorscheme-nvim",
    lazy = false,
    priority = 500
  }
}
