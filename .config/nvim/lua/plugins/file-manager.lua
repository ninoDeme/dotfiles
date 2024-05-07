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
			},
      win_options = {
        -- winbar = ' %#WinBarPathAbs#%{GetOilDirAbs()}%#WinBarPathRel#%{GetOilDirRel()}%#WinBar#',
        winbar = '     %#WinBarPathRel#%{luaeval("GetOilDir()")}:',
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
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
}
