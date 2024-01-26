return {
	"nvim-lua/plenary.nvim",
	"MunifTanjim/nui.nvim",
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			filetype_exclude = { "help", "alpha", "dashboard", "NvimTree", "Trouble", "lazy", "mason" },
			show_trailing_blankline_indent = false,
			show_current_context = true,
			show_end_of_line = true,
		},
		config = function()
			require("ibl").setup({

				indent = {
					char = "▏",
					-- highlight = { "Function" },
					repeat_linebreak = false,
				},
				scope = {
					show_start = false,
				},
			})
		end,
	},
	{
		"abecodes/tabout.nvim",
		event = "VeryLazy",
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"hrsh7th/nvim-cmp",
		},
		config = true,
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
			-- background_colour = "#A3CCBE",
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
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
		keys = { { "gc", mode = { "n", "v" } }, { "gcc", mode = { "n", "v" } }, { "gbc", mode = { "n", "v" } } },
		config = function(_, _)
			local opts = {
				ignore = "^$",
				-- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
			}
			require("Comment").setup(opts)
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
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next ToDo" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous ToDo" },
      { "<leader>cT", "<cmd>TodoTrouble<cr>", desc = "ToDo (Trouble)" },
      { "<leader>ct", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
    },
	},

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
    --stylua: ignore
    keys = {
      { "<leader>vO", function() require("nvim-navbuddy").open() end, desc = "Code Outline (navbuddy)", },
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
    -- stylua: ignore
    init = function()
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
    end,
		config = function(_, opts)
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
		"lewis6991/gitsigns.nvim",
		event = "BufReadPre",
		opts = {
			signs = {
				add = { hl = "GitSignsAdd", text = "▍", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
				change = {
					hl = "GitSignsChange",
					text = "▍",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
				delete = {
					hl = "GitSignsDelete",
					text = "▸",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				topdelete = {
					hl = "GitSignsDelete",
					text = "▾",
					numhl = "GitSignsDeleteNr",
					linehl = "GitSignsDeleteLn",
				},
				changedelete = {
					hl = "GitSignsChange",
					text = "▍",
					numhl = "GitSignsChangeNr",
					linehl = "GitSignsChangeLn",
				},
			},
			-- update_debounce = 100,
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				map("n", "]c", function()
					if vim.wo.diff then
						return "]c"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				map("n", "[c", function()
					if vim.wo.diff then
						return "[c"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true })

				-- Actions
				map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
				map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
				map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
				map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
				map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
				map("n", "<leader>ghp", gs.preview_hunk, { desc = "Preview Hunk" })
				map("n", "<leader>ghb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame Line" })
				map("n", "<leader>gtb", gs.toggle_current_line_blame, { desc = "Toggle Line Blame" })
				map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
				map("n", "<leader>ghD", function()
					gs.diffthis("~")
				end, { desc = "Diff This ~" })
				map("n", "<leader>gtd", gs.toggle_deleted, { desc = "Toggle Delete" })

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
			end,
		},
	},
}
