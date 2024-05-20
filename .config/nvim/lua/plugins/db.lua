return {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
    event = "VeryLazy",
    dev = true,
		-- build = function()
		-- 	-- Install tries to automatically detect the install method.
		-- 	-- if it fails, try calling it with one of these parameters:
		-- 	--    "curl", "wget", "bitsadmin", "go"
		-- 	require("dbee").install('go')
		-- end,
		config = function()
			require("dbee").setup( --[[optional config]])
		end,
	},
}
