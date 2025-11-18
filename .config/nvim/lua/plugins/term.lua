return {
  {
    "skywind3000/asyncrun.vim",
    cmd = {
      "AsyncRun",
    },
    init = function()
      vim.g.asyncrun_open = 16
    end,
    keys = {
      { "<leader><cr>", ":AsyncRun<space>", desc = "Run Command" },
    }
  },
  {
    "ninodeme/overseer.nvim",
    event = "VeryLazy",
    dev = true,
    init = function()
      require("which-key").add({
        { "<leader>r", group = "+Task Runner" }
      })
    end,
    config = function()
      require("overseer").setup({
        dap = false,
        task_list = {
          bindings = {
            ["?"] = "ShowHelp",
            ["g?"] = "ShowHelp",
            ["<CR>"] = "RunAction",
            ["<C-e>"] = "Edit",
            ["o"] = "Open",
            ["<C-v>"] = "OpenVsplit",
            ["<C-s>"] = "OpenSplit",
            ["<C-f>"] = "OpenFloat",
            ["<C-q>"] = "OpenQuickFix",
            ["p"] = "TogglePreview",
            ["<C-l>"] = "IncreaseDetail",
            ["<C-h>"] = "DecreaseDetail",
            ["L"] = "IncreaseAllDetail",
            ["H"] = "DecreaseAllDetail",
            ["["] = "DecreaseWidth",
            ["]"] = "IncreaseWidth",
            ["{"] = "PrevTask",
            ["}"] = "NextTask",
            ["C-p"] = "PrevTask",
            ["C-n"] = "NextTask",
            ["<C-k>"] = "ScrollOutputUp",
            ["<C-j>"] = "ScrollOutputDown",
            ["q"] = "Close",
            ["r"] = "<CMD>OverseerQuickAction restart<CR>",
          },
          direction = "left"
        },
        task_win = {
          -- How much space to leave around the floating window
          padding = 2,
          -- border = require('hover').border,
          -- Set any window options here (e.g. winhighlight)
          win_opts = {
            winblend = 0,
          },
        },
      })

      local function get_search_params()
        -- If we have a file open, use its parent dir as the search dir.
        -- Otherwise, use the current working directory.
        local dir = vim.fn.getcwd()
        if vim.bo.buftype == "" then
          local bufname = vim.api.nvim_buf_get_name(0)
          if bufname ~= "" then
            dir = vim.fn.fnamemodify(bufname, ":p:h")
          end
        end
        return {
          dir = dir,
          filetype = vim.bo.filetype,
        }
      end

      local run_template_picker = function()
        local search_params = get_search_params()
        require("overseer.template").list(search_params, function(templates)
          templates = vim.tbl_filter(function(tmpl)
            return not tmpl.hide
          end, templates)

          if #templates == 0 then
            error("Could not find any task templates")
          end
          -- elseif #templates == 1 then
          -- 	handle_tmpl(templates[1])
          -- else

          local items = {}

          for idx, tmpl in ipairs(templates) do
            local item = {
              idx = idx,
              name = tmpl.name,
              text = tmpl.name,
              action = tmpl.name,
              preview = {
                text = vim.inspect(tmpl),
                ft = "lua"
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
              return { { item.text, items.text_hl } }
            end,
            confirm = function(picker, item)
              local selection = picker:selected({ fallback = true })

              if not selection or #selection == 0 then
                selection = {
                  item
                }
              end
              return picker:norm(
                function()
                  picker:close()
                  for _, tmpl in ipairs(selection) do
                    require("overseer").run_task({ name = tmpl.action })
                  end
                end
              )
            end,
          })
        end)
      end

      vim.keymap.set("n", "<leader>rr", run_template_picker, { desc = "Overseer Run" })
    end,

    keys = {
      { "<leader>rr", desc = "Overseer Run (Picker)" },
      { "<leader>rR", "<cmd>OverseerRun<CR>",                 desc = "Overseer Run (vim.select)" },
      { "<leader>rR", "<cmd>OverseerQuickAction restart<CR>", desc = "Overseer Restart Action" },
      { "<leader>rt", "<cmd>OverseerToggle<CR>",              desc = "Overseer Toggle" },
      { "<leader>ri", "<cmd>OverseerInfo<CR>",                desc = "Overseer Info" },
      { "<leader>ra", "<cmd>OverseerTaskAction<CR>",          desc = "Overseer Task Actions" },
    },
  }
}
