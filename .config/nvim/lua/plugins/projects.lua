return {
  {
    'gnikdroy/projections.nvim',
    enabled = false,
    branch = 'main',
    config = function()
      require('projections').setup({
        workspaces = {
          -- { "~/Documents/dev", { ".git" } },        Documents/dev is a workspace. patterns = { ".git" }
          -- { "~/repos", {} },                        An empty pattern list indicates that all subdirectories are considered projects
          -- "~/dev",                                  dev is a workspace. default patterns is used (specified below)
          {"~/Documents/limber-hub-marketplace", {}}
        },
        -- patterns = { ".git", ".svn", ".hg" },      -- Default patterns to use if none were specified. These are NOT regexps.
        -- store_hooks = { pre = nil, post = nil },   -- pre and post hooks for store_session, callable | nil
        -- restore_hooks = { pre = nil, post = nil }, -- pre and post hooks for restore_session, callable | nil
        -- workspaces_file = "path/to/file",          -- Path to workspaces json file
        -- sessions_directory = "path/to/dir",        -- Directory where sessions are stored
      })
      require("telescope").load_extension('projections')
      local switcher = require("projections.switcher")
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function()
          if vim.fn.argc() == 0 then switcher.switch(vim.uv.cmd()) end
        end,
      })
      local Workspace = require("projections.workspace")
      -- Add workspace command
      vim.api.nvim_create_user_command("AddWorkspace", function()
        Workspace.add(vim.uv.cwd())
      end, {})
    end,
    event = "VeryLazy",
    keys = {
      {'<leader>sp', function() vim.cmd("Telescope projections") end, desc = 'Change Project'}
    }
  }
}
