return {
	{
		"kndndrj/nvim-dbee",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
    dev = true,
    cmd = {
      'Dbee',
    },
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
	-- {
	-- 	"tpope/vim-dadbod",
	--    cmd = {
	--      'DB'
	--    }
	-- },
}
