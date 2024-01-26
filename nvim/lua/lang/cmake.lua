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
			setup = {
				cmake = function()
					local lsp_utils = require("plugin.lsp.utils")
					lsp_utils.on_attach(function(client, _)
						if client.name == "cmake" then
						end
					end)
				end,
			},
		},
	},
}
