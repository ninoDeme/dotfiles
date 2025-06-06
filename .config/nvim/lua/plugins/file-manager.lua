-- GetOilDirRel = function()
--   local plenary = require('plenary')
--   local path = plenary.path:new(require('oil').get_current_dir()):make_relative(
--     plenary.path.new(vim.uv.cwd()):joinpath('..'):absolute()
--   )
--   if path == "." then
--     return plenary.path:new(require('oil').get_current_dir()):make_relative() .. "/"
--   end
--   return path .. "/"
-- end
--
-- GetOilDirAbs = function()
--   local absolute = require('oil').get_current_dir()
--   local relative = GetOilDirRel()
--   if relative == "/." then
--     return absolute:sub(0, -1)
--   end
--   if absolute:sub(-#relative) == relative then
--     return absolute:sub(0, -#relative - 1)
--   end
--   return ""
-- end
--
-- vim.cmd([[
--   function! GetOilDirRel()
--     return luaeval("GetOilDirRel()")
--   endfunction
--   function! GetOilDirAbs()
--     return luaeval("GetOilDirAbs()")
--   endfunction
-- ]])

function GetOilDir()
  return require('oil').get_current_dir()
end

return {
  {
    "stevearc/oil.nvim",
    opts = {
      keymaps = {
        ["<C-l>"] = "actions.select",
        ["gr"] = "actions.refresh",
        ["g:"] = "actions.open_cmdline",
        ["g;"] = "actions.open_cmdline_dir",
        ["<leader>ot"] = "actions.open_terminal",
        ['!'] = {
          desc = "Run shell command",
          callback = function()
            local oil = require("oil")
            -- require("oil.actions").cd.callback({ scope = 'win', silent = true })

            local cwd = oil.get_current_dir()

            local cmd = vim.fn.input({
              prompt = "!",
              completion = "custom,CompleteShell"
            })
            if cmd == "" then return end
            local result = ""
            local i = 1
            local flags = { '-cwd=' .. cwd }
            if cmd:sub(i, i) == '!' then
              i = i + 1
              table.insert(flags, '-mode=terminal')
            end
            while i <= #cmd do
              local char = cmd:sub(i, i)
              if char == "%" then
                local entry = oil.get_cursor_entry()
                local entry_name = cwd .. (entry and (entry.parsed_name or entry.name) or "")
                local expands = ""
                local next_char = cmd:sub(i + 1, i + 1)
                while next_char == ':' do
                  i = i + 2
                  expands = expands .. ":" .. cmd:sub(i, i)
                  next_char = cmd:sub(i + 1, i + 1)
                end
                if expands ~= "" then
                  entry_name = vim.fn.fnamemodify(entry_name, expands)
                end
                result = result .. (entry_name or "")
              else
                result = result .. char
              end
              i = i + 1
            end
            -- local cmd_list = vim.fn.split(vim.o.shell)
            -- for _, value in ipairs(vim.fn.split(vim.o.shellcmdflag)) do
            --   table.insert(cmd_list, value)
            -- end
            -- table.insert(cmd_list, result)
            -- local handle = vim.system(cmd_list, {
            --   cwd = cwd,
            --   text = true,
            -- }):wait()
            -- local out = handle.stdout
            -- vim.api.nvim_echo({ { vim.inspect(cmd_list) .. "\n" .. out } }, false, {})
            local flags_str = ""
            for _, value in ipairs(flags) do
              flags_str = flags_str .. " " .. value
            end
            vim.cmd['AsyncRun'](string.format('%s %s', flags_str, result))
            -- vim.cmd['!'](result)
            -- vim.cmd([[silent lcd ]] .. original_cwd)
          end
        }
      },
      win_options = {
        -- winbar = ' %#WinBarPathAbs#%{GetOilDirAbs()}%#WinBarPathRel#%{GetOilDirRel()}%#WinBar#',
        winbar = '     %#WinBarPathRel#%{luaeval("GetOilDir()")}:',
        wrap = false,
        -- signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
        signcolumn = "yes:2",
      },
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
      },
      columns = {
        {
          "permissions",
        },
        {
          "size",
          highlight = "OilSize",
        },
        {
          "mtime",
          highlight = "OilMtime",
        },
        {
          "icon",
          directory = "",
          -- directory = "",
          -- directory = "",
        },
      },
      keymaps_help = {
        border = require("hover").alt_border,
        win_opts = {
          winhighlight = "Normal:FloatNormal",
        },
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  },
  {
    "refractalize/oil-git-status.nvim",
    dependencies = {
      "stevearc/oil.nvim",
    },
    config = true,
    event = 'VeryLazy'
  },
}
