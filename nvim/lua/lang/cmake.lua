return {
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "cmake-language-server" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				cmake = {},
			},
		},
	},
}
