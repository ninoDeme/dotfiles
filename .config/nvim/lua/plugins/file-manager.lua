return {
  {
    'stevearc/oil.nvim',
    opts = {
      keymaps = {
        ["<C-l>"] = "actions.select",
        ["gr"] = "actions.refresh",
      },
      columns = {
        "permissions",
        "size",
        "mtime",
        "icon",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
  }
}
