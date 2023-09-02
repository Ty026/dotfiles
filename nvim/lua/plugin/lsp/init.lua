return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			--{ "j-hui/fidget.nvim", config = true, tag = "legacy" },
			{ "smjonas/inc-rename.nvim", config = true },
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jay-babu/mason-null-ls.nvim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
		},
		opts = {
			servers = {},
			setup = {},
			format = {
				timeout_ms = 3000,
			},
		},
		config = function(plugin, opts)
			require("plugin.lsp.servers").setup(plugin, opts)
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {
			input_buffer_type = "dressing",
		},
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		cmd = "Mason",
		opts = {
			ensure_installed = { "shfmt" },
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		event = "BufReadPre",
		dependencies = { "mason.nvim" },
		opts = function()
			local nls = require("null-ls")
			return {
				root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
				sources = {
					nls.builtins.formatting.shfmt,
				},
			}
		end,
	},
	{
		"jay-babu/mason-null-ls.nvim",
		opts = { ensure_installed = nil, automatic_installation = true, automatic_setup = false },
	},
	{
		"nvimdev/lspsaga.nvim",
		event = "VeryLazy",
		opts = {
			symbol_in_winbar = { enable = false },
			lightbulb = { enable = false },
		},
		keys = {
			{ "<C-y>", "<cmd>Lspsaga diagnostic_jump_next<cr>" },
		},
	},
	{
		"folke/trouble.nvim",
		cmd = { "TroubleToggle", "Trouble" },
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>cd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
			{ "<leader>cD", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		},
	},
}
