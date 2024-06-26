return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neoconf.nvim", cmd = "Neoconf", config = true },
			"smjonas/inc-rename.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"nvimtools/none-ls.nvim",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			"SmiteshP/nvim-navbuddy",
			dependencies = {
				"SmiteshP/nvim-navic",
				"MunifTanjim/nui.nvim",
			},
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
		"nvimtools/none-ls.nvim",
		event = { "BufReadPre", "BufNewFile" },
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
}
