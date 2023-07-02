function telescope_buffer_dir()
	local dir = vim.fn.expand("%:p:h")
	print(dir)
	return dir
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
		},
		cmd = "Telescope",
		keys = {
			{ "<leader>f", "<cmd>Telescope find_files<cr>" },
			{
				"<leader>e",
				'<cmd>lua require("telescope").extensions.file_browser.file_browser({ path="%:p:h", cwd =telescope_buffer_dir(), respect_git_ignore = false, hidden = true, grouped = true, previewer = false, initial_mode = "normal", layout_config = { height=40 } })<CR>',
			},
			{ "<leader>vo", "<cmd>Telescope aerial<cr>", desc = "Code Outline" },
			{ "<leader>l", "<cmd>Telescope live_grep<cr>", desc = "Workspace" },
			{ "<leader>gc", "<cmd>Telescope conventional_commits<cr>", desc = "Conventional Commits" },
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
		end,
	},
	{
		"stevearc/aerial.nvim",
		config = true,
	},
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				detection_methods = { "pattern", "lsp" },
				patterns = { ".git" },
				ignore_lsp = { "null-ls" },
			})
		end,
	},
}
