return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "html", "css" })
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "prettierd" })
		end,
	},
	{
		"neovim/nvim-lspconfig",
		opts = {
			servers = {
				glslls = {
					cmd = { "glslls", "--stdin", "--target-env", "opengl" },
				},
			},
			setup = {
				glslls = function()
					require("plugin.lsp.utils").on_attach(function(client, _)
						if client.name == "glslls" then
							-- not applicable to cmp_nvim_lsp_signature_help.
							client.server_capabilities.signatureHelpProvider = nil
						end
					end)
				end,
			},
		},
	},
}
