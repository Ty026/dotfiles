return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, { "dart" })
		end,
	},

	{
		"akinsho/flutter-tools.nvim",
		event = "VeryLazy",
		opts = function()
			local line = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
			return {
				ui = { border = line },
				debugger = {
					enabled = false,
					run_via_dap = false,
					exception_breakpoints = {},
				},
				outline = { auto_open = false },
				decorations = {
					statusline = { device = true, app_version = true },
				},
				widget_guides = { enabled = true, debug = false },
				dev_log = {
					enabled = true,
					-- open_cmd = "tabedit",
					open_cmd = "15new",
				},
				lsp = {
					color = {
						enabled = true,
						background = true,
						virtual_text = false,
					},
					settings = {
						showTodos = false,
						renameFilesWithClasses = "always",
						updateImportsOnRename = true,
						completeFunctionCalls = true,
						lineLength = 100,
					},
				},
			}
		end,
		dependencies = {
			{ "RobertBrunhage/flutter-riverpod-snippets" },
		},

		config = function(_, opts)
			require("plugin.lsp.utils").on_attach(function(client, bufnr)
				if client.name == "dartls" then
					vim.keymap.set(
						"n",
						"<S-b>",
						"<cmd>Telescope flutter commands<cr>",
						{ buffer = bufnr, desc = "Flutter" }
					)
					vim.keymap.set(
						"n",
						"<leader>vo",
						"<cmd>FlutterOutlineToggle<cr>",
						{ buffer = bufnr, desc = "Flutter Outline" }
					)
				end
			end)
			require("flutter-tools").setup(opts)
		end,
	},
}
