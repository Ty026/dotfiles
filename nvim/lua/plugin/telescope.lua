function telescope_buffer_dir()
	return vim.fn.expand("%:p:h")
end

return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			"nvim-telescope/telescope-file-browser.nvim",
			"ahmedkhalf/project.nvim",
			"stevearc/aerial.nvim",
			"olacin/telescope-cc.nvim",
			"akinsho/toggleterm.nvim",
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>f", "<cmd>Telescope find_files<cr>" },
			{
				"<leader>e",
				'<cmd>lua require("telescope").extensions.file_browser.file_browser({ path="%:p:h", cwd =telescope_buffer_dir(), respect_git_ignore = false, hidden = true, grouped = true, previewer = false, initial_mode = "normal", layout_config = { height=40 } })<CR>',
			},
			{ "<leader>vo", "<cmd>Telescope aerial<cr>", desc = "Code Outline" },
			{ "<leader>l", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>", desc = "" },
			-- { "<leader>gc", "<cmd>Telescope conventional_commits<cr>", desc = "Conventional Commits" },
		},

		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local fb_actions = require("telescope").extensions.file_browser.actions
			local mappings = {
				i = {
					["<c-l>"] = actions.select_vertical,
					["<c-h>"] = actions.select_horizontal,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
				n = {
					["q"] = actions.close,
					["<c-l>"] = actions.select_vertical,
					["<c-h>"] = actions.select_horizontal,
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
				},
			}
			local file_ignore_patterns = {
				".git/",
				"3rdparty/",
				"__pycache__/",
			}
			telescope.setup({
				defaults = {
					mappings = mappings,
					file_ignore_patterns = file_ignore_patterns,
				},
				extensions = {
					file_browser = {
						theme = "dropdown",
						hijack_netrw = true,
						mappings = {
							["i"] = {
								["<C-w"] = function()
									vim.cmd("normal vbd")
								end,
								["<C-d>"] = fb_actions.remove,
								["<C-r>"] = fb_actions.rename,
								["<C-y>"] = fb_actions.copy,
							},
							["n"] = {
								["<C-d>"] = fb_actions.remove,
								["<C-r>"] = fb_actions.rename,
								["<C-y>"] = fb_actions.copy,
								["N"] = fb_actions.create,
								["h"] = fb_actions.goto_parent_dir,
								["/"] = function()
									vim.cmd("startinsert")
								end,
							},
						},
					},
				},
			})
			telescope.load_extension("file_browser")
			telescope.load_extension("aerial")
			telescope.load_extension("conventional_commits")
			-- telescope.load_extension("flutter")
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = true,
	},
	{
		"akinsho/toggleterm.nvim",
		cmd = { "ToggleTerm", "TermExec" },
		keys = {
			{ "<C-t>", "<cmd>ToggleTerm<cr>" },
			{ "<leader>0", "<Cmd>2ToggleTerm<Cr>", desc = "Terminal #2" },
		},
		opts = {
			open_mapping = [[<C-\>]],
			size = 20,
			hide_numbers = true,
			shade_filetypes = {},
			shade_terminals = false,
			shading_factor = 0.3,
			start_in_insert = true,
			persist_size = true,
			-- direction = "",
			winbar = {
				enabled = false,
				name_formatter = function(term)
					return term.name
				end,
			},
		},
		config = function(_, opts)
			require("toggleterm").setup(opts)
			local Terminal = require("toggleterm.terminal").Terminal
			local lazygit = Terminal:new({
				cmd = "lazygit",
				dir = "git_dir",
				direction = "float",
				on_open = function(term)
					vim.cmd("startinsert!")
					vim.api.nvim_buf_set_keymap(
						term.bufnr,
						"n",
						"q",
						"<cmd>close<CR>",
						{ noremap = true, silent = true }
					)
				end,
				on_close = function(_)
					vim.cmd("startinsert!")
				end,
			})

			function _LazygitToggle()
				lazygit:toggle()
			end
			vim.keymap.set("n", "<leader>g", "<cmd>lua _LazygitToggle()<cr>")
		end,
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git", "package.json", "go.mod", "requirements.txt" },
				ignore_lsp = { "null-ls" },
			})
		end,
	},
}
