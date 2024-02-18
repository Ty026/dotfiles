return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
		},
		keys = {
			{
				"<leader>vo",
				function()
					require("nvim-navbuddy").open()
				end,
				desc = "Code Outline (navbuddy)",
			},
		},
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("ibl").setup({
				indent = { char = "▏", repeat_linebreak = false },
				scope = { show_start = false },
			})
		end,
	},
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {
			input = { relative = "editor" },
			select = {
				backend = { "telescope", "fzf", "builtin" },
			},
		},
	},
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		lazy = false,
		opts = {
			timeout = 996,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
		},
		config = function(_, opts)
			require("notify").setup(opts)
			vim.notify = require("notify")
		end,
	},
	{
		"smjonas/inc-rename.nvim",
		opts = {
			input_buffer_type = "dressing",
		},
		config = function()
			require("inc_rename").setup({
				input_buffer_type = "dressing",
			})
		end,
	},
	{
		"abecodes/tabout.nvim",
		event = "VeryLazy",
		dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
		config = true,
	},
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
		config = function(_, _)
			local opts = { ignore = "^$" }
			require("Comment").setup(opts)
		end,
	},
	{
		"andymass/vim-matchup",
		event = { "BufReadPost" },
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	},
	{
		"kylechui/nvim-surround",
		event = "BufReadPre",
		opts = {},
	},
	{ "yamatsum/nvim-nonicons", config = true, enabled = false },
	{ "tpope/vim-repeat", event = "VeryLazy" },
	{ "nacro90/numb.nvim", event = "BufReadPre", config = true },
	{
		"folke/todo-comments.nvim",
		cmd = { "TodoTrouble", "TodoTelescope" },
		event = "BufReadPost",
		config = true,
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next ToDo",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Previous ToDo",
			},
			{ "<leader>cT", "<cmd>TodoTrouble<cr>", desc = "ToDo (Trouble)" },
			{ "<leader>ct", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
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
	{
		"monaqa/dial.nvim",
		keys = {
			{ "<C-a>", mode = { "n", "v" } },
			{ "<C-x>", mode = { "n", "v" } },
			{ "g<C-a>", mode = { "v" } },
			{ "g<C-x>", mode = { "v" } },
		},
		init = function()
			vim.api.nvim_set_keymap(
				"n",
				"<C-a>",
				require("dial.map").inc_normal(),
				{ desc = "Increment", noremap = true }
			)
			vim.api.nvim_set_keymap(
				"n",
				"<C-x>",
				require("dial.map").dec_normal(),
				{ desc = "Decrement", noremap = true }
			)
			vim.api.nvim_set_keymap(
				"v",
				"<C-a>",
				require("dial.map").inc_visual(),
				{ desc = "Increment", noremap = true }
			)
			vim.api.nvim_set_keymap(
				"v",
				"<C-x>",
				require("dial.map").dec_visual(),
				{ desc = "Decrement", noremap = true }
			)
			vim.api.nvim_set_keymap(
				"v",
				"g<C-a>",
				require("dial.map").inc_gvisual(),
				{ desc = "Increment", noremap = true }
			)
			vim.api.nvim_set_keymap(
				"v",
				"g<C-x>",
				require("dial.map").dec_gvisual(),
				{ desc = "Decrement", noremap = true }
			)
		end,
		config = function(_, _)
			local augend = require("dial.augend")
			require("dial.config").augends:register_group({
				default = {
					augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
					augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
					augend.date.alias["%Y/%m/%d"], -- date (2022/02/19, etc.)
					augend.constant.new({ elements = { "and", "or" }, word = true, cyclic = true }),
					augend.constant.new({ elements = { "&&", "||" }, word = false, cyclic = true }),
					augend.constant.new({ elements = { "true", "false" }, word = false, cyclic = true }),
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		config = function()
			require("nvim-web-devicons").setup({
				override = require("config/material_icons"),
				override_by_extension = {
					["json"] = {
						icon = "",
						color = "#81e043",
						name = "JSON",
					},
				},
			})
		end,
	},
	{
		"akinsho/nvim-bufferline.lua",
		event = "VeryLazy",
		opts = {
			options = {
				mode = "tabs", -- tabs or buffers
				numbers = "buffer_id",
				diagnostics = "nvim_lsp",
				always_show_bufferline = false,
				separator_style = "slant" or "padded_slant",
				show_tab_indicators = true,
				show_buffer_close_icons = false,
				show_close_icon = false,
				color_icons = true,
				enforce_regular_tabs = false,
				custom_filter = function(buf_number, _)
					local tab_num = 0
					for _ in pairs(vim.api.nvim_list_tabpages()) do
						tab_num = tab_num + 1
					end

					if tab_num > 1 then
						if not not vim.api.nvim_buf_get_name(buf_number):find(vim.fn.getcwd(), 0, true) then
							return true
						end
					else
						return true
					end
				end,
			},
		},
	},
	{
		"folke/which-key.nvim",
		cond = function()
			return true
		end,
		event = "VeryLazy",
		opts = {
			setup = {
				show_help = true,
			},
		},
	},
}
