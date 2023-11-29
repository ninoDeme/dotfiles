local logo = {
  "                                                     ",
  "                                                     ",
  "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ",
  "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ",
  "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ",
  "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ",
  "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ",
  "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ",
}

return {
  {
    'goolord/alpha-nvim',
    lazy = false,
    dependencies = { 'nvim-web-devicons' },
    config = function ()

      local dashboard = require "alpha.themes.dashboard"
      dashboard.section.header.val = logo
      dashboard.section.buttons.val = {
        dashboard.button("SPC s r", "  Recent Files"),
        dashboard.button("SPC s f", "󰈞  Find File"),
        dashboard.button("SPC s t", "  Find Text"),
        dashboard.button("SPC s e", "󰝰  Open File Browser"),
        dashboard.button("n", "  New file", ":e<CR>"),
        dashboard.button("c", "  Configuration", ":e $MYVIMRC | :cd %:p:h<CR>"),
        dashboard.button("u", "  Update Plugins", ":Lazy update<CR>"),
        dashboard.button("q", "󰗼  Quit Neovim", ":qa!<CR>"),
      }

      dashboard.leader = "SPC"
      for _,v in ipairs(dashboard.section.buttons.val) do
        v.opts.hl = "DashboardShortCut"
      end
      

      dashboard.opts.opts.autocmd = true
      require('alpha').setup(dashboard.opts)
      vim.cmd[[autocmd FileType alpha setlocal nonumber norelativenumber]]

      local bufnr = vim.api.nvim_get_current_buf()
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      local stats = vim.uv.fs_stat(bufname)
      local is_dir = stats and stats.type == "directory"
      local lines = not is_dir and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) or {}
      local buf_has_content = #lines > 1 or (#lines == 1 and lines[1] ~= "")

      local footer = function()
        local version = " " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
        local lazy_ok, lazy = pcall(require, "lazy")
        if lazy_ok then
          local total_plugins = "  󰒲 " .. lazy.stats().count .. " Plugins"
          local startuptime = (math.floor(lazy.stats().startuptime * 100 + 0.5) / 100)
          return version .. total_plugins .. " 󱎫 " .. startuptime .. "ms"
        else
          return version
        end
      end

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          dashboard.section.footer.val = footer()
          if is_dir or (bufname == "" and not buf_has_content) then
            vim.api.nvim_buf_delete(0, {})
            require("alpha").start()
          end
        end,
        desc = "Footer for Alpha",
      })
      if is_dir or (bufname == "" and not buf_has_content) then
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        vim.g.loaded_netrwSettings = 1
        vim.g.loaded_netrwFileHandlers = 1
      end
    end,
    cond = NOT_VSCODE
  };
}
