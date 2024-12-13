return {
  {
    "lukas-reineke/indent-blankline.nvim",
    enabled = false,
    main = "ibl",
    event = "VeryLazy",
    config = function()

      require("ibl").setup({
        enabled = true,
        exclude = {
          filetypes = {
            "help",
            "terminal",
            "lazy",
            "lspinfo",
            "TelescopePrompt",
            "TelescopeResults",
            "mason",
            "alpha",
            "",
          },
          buftypes = {
            "terminal",
          },
        },

        indent = {
          char = "│",
          -- char = "▎",
          highlight = "IblChar",
        },

        scope = {
          char = "│",
          -- char = "▎",
          highlight = "IblScopeChar",
        },
      })
    end,
  },
}
