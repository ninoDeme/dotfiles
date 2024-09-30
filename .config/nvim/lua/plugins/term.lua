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
      -- { "<leader><cr>", ":AsyncRun<space>", desc = "Run Command" },
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
          border = require("hover").alt_border,
          -- Set any window options here (e.g. winhighlight)
          win_opts = {
            winblend = 0,
            winhighlight = "Normal:FloatNormal",
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

      local telescope_run_template = function()
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
          local pickers = require("telescope.pickers")
          local finders = require("telescope.finders")
          local previewers = require("telescope.previewers")
          local conf = require("telescope.config").values
          local actions = require("telescope.actions")
          local action_state = require("telescope.actions.state")

          pickers
              .new({}, {
                prompt_title = "Task Template",
                -- layout_strategy = "bottom_pane",
                theme = 'ivy',
                finder = finders.new_table({
                  results = templates,
                  entry_maker = function(tmpl)
                    return {
                      value = tmpl,
                      display = tmpl.desc and string.format("%s (%s)", tmpl.name, tmpl.desc)
                          or tmpl.name,
                      ordinal = tmpl.desc and string.format("%s (%s)", tmpl.name, tmpl.desc)
                          or tmpl.name,
                    }
                  end,
                }),
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                  actions.select_default:replace(function()
                    local picker = action_state.get_current_picker(prompt_bufnr)
                    actions.close(prompt_bufnr)

                    local selection = picker:get_multi_selection()

                    if not selection or #selection == 0 then
                      selection = {
                        action_state.get_selected_entry(),
                      }
                    end
                    for _, tmpl in ipairs(selection) do
                      require("overseer").run_template({ name = tmpl.value.name })
                    end
                  end)
                  return true
                end,
                previewer = previewers.new_buffer_previewer({
                  define_preview = function(self, entry, status)
                    local t = {}
                    for str in string.gmatch(vim.inspect(entry.value), "([^\n]+)") do
                      table.insert(t, str)
                    end
                    vim.fn.setbufline(self.state.bufnr, 1, t)
                    vim.api.nvim_set_option_value("filetype", "lua", { buf = self.state.bufnr })
                  end,
                }),
              })
              :find()
        end)
      end

      vim.keymap.set("n", "<leader>rr", telescope_run_template, { desc = "Overseer Run" })
    end,

    keys = {
      { "<leader>rr", desc = "Overseer Run (telescope)" },
      { "<leader>rR", "<cmd>OverseerRun<CR>",                 desc = "Overseer Run (vim.select)" },
      { "<leader>rR", "<cmd>OverseerQuickAction restart<CR>", desc = "Overseer Restart Action" },
      { "<leader>rt", "<cmd>OverseerToggle<CR>",              desc = "Overseer Toggle" },
      { "<leader>ri", "<cmd>OverseerInfo<CR>",                desc = "Overseer Info" },
      { "<leader>ra", "<cmd>OverseerTaskAction<CR>",          desc = "Overseer Task Actions" },
    },
  },
  {
    "m00qek/baleia.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  }
}
