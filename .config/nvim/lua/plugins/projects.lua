return {
	{
		"ahmedkhalf/project.nvim",
		event = "VeryLazy",
		config = function()
			require("project_nvim").setup({
				manual_mode = false,
				show_hidden = true,
				silent_chdir = false,
        scope_chdir = 'tab',
        detection_methods = { "pattern", "lsp" },
				patterns = { ">Projects", ".git", "_darcs", ".hg", ".bzr", ".svn" },
			})
			require("telescope").load_extension("projects")
		end,
		keys = {
			{ "<leader>sp", function() require("telescope").extensions.projects.projects({}) end, desc = "Projects"},
		},
	},
}
