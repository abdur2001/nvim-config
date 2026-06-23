return {
	"tpope/vim-fugitive",
	cmd = {
		"Git",
		"G",
		"Gdiffsplit",
		"Gvdiffsplit",
		"Gread",
		"Gwrite",
		"Ggrep",
		"GMove",
		"GRename",
		"GDelete",
		"GBrowse",
	},
	event = "BufReadPost",
	config = function()
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fugitive",
			callback = function()
				vim.cmd("resize 15")
			end,
		})
	end,
}
