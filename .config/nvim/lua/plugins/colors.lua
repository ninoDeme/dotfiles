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
    "ninoDeme/base46",
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
              text = vim.inspect(require('base46.themes.' .. tmpl)),
              ft = 'lua'
            }
          }
          table.insert(items, item)
        end
        local last_color = vim.g.colors_name
        local last_color_base46 = require('base46').opts.theme
        local picked = false
        Snacks.picker({
          title = "Base46 Themes",
          items = items,
          layout = {
            preset = "ivy",
          },
          preview = "preview",
          format = function(item, _)
            return { { item.text, item.text_hl, item.ft } }
          end,
          on_close = function()
            if not picked then
              vim.schedule(function()
                if last_color:find('base46') then
                  require('base46').apply_theme(last_color_base46)
                else
                  vim.cmd.colorscheme(last_color)
                end
              end)
            end
          end,
          on_change = function(picker, item)
            vim.schedule(function()
              require('base46').apply_theme(item.action)
            end)
          end,
          confirm = function(picker, item)
            return picker:norm(
              function()
                picked = true
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
