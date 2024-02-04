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
				html = {
					filetypes = {
						"html",
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
				},
				emmet_ls = {
					init_options = {
						html = {
							options = { ["bem.enabled"] = true },
						},
					},
				},
				cssls = {},
				tailwindcss = { filetypes_exclude = { "markdown" } },
			},
			setup = {
				tailwindcss = function(_, opts)
					local tw = require("lspconfig.server_configurations.tailwindcss")
					opts.filetypes = vim.tbl_filter(function(ft)
						return not vim.tbl_contains(opts.filetypes_exclude or {}, ft)
					end, tw.default_config.filetypes)
				end,
			},
		},
	},
	{
		"nvimtools/none-ls.nvim",
		opts = function(_, opts)
			local nls = require("null-ls")
			table.insert(opts.sources, nls.builtins.formatting.prettierd)
		end,
	},
	{
		"uga-rosa/ccc.nvim",
		opts = {},
		cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
		keys = {
			{ "<leader>pp", "<cmd>CccPick<cr>", desc = "Pick" },
			{ "<leader>pC", "<cmd>CccConvert<cr>", desc = "Convert" },
			{ "<leader>pc", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
		},
	},
}
