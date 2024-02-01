return {
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_foreground = "material"
			vim.g.gruvbox_material_background = "hard"
			vim.cmd([[colorscheme gruvbox-material]])
		end,
	},
	-- {
	-- 	"ellisonleao/gruvbox.nvim",
	-- 	lazy = false,
	-- 	config = function()
	-- 		require("gruvbox").setup()

	-- 		vim.cmd([[colorscheme gruvbox]])
	-- 	end,
	-- },
}
