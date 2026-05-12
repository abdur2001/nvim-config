return {
	"nvim-lualine/lualine.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = {
		theme = "everforest",
		sections = {
			lualine_a = {
				{
					"filename",
					path = 1,
				},
			},
		},
	},
}
