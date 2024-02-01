return {
	{
		"Exafunction/codeium.vim",
		event = "InsertEnter",
      -- stylua: ignore
      config = function ()
        vim.g.codeium_disable_bindings = 1
        vim.keymap.set("i", "<A-m>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
        vim.keymap.set("i", "<A-f>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
        vim.keymap.set("i", "<A-b>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
        vim.keymap.set("i", "<A-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
        vim.keymap.set("i", "<A-s>", function() return vim.fn["codeium#Complete"]() end, { expr = true })
      end,
	},
	{
		"jackMort/ChatGPT.nvim",
		cmd = { "ChatGPT", "ChatGPTRun", "ChatGPTActAs", "ChatGPTCompleteCode", "ChatGPTEditWithInstructions" },
		keys = {
			{ "<leader>aa", "<cmd>ChatGPT<cr>", desc = "Chat" },
			{ "<leader>ac", "<cmd>ChatGPTRun complete_code<cr>", mode = { "n", "v" }, desc = "Complete Code" },
			{
				"<leader>ae",
				"<cmd>ChatGPTEditWithInstructions<cr>",
				mode = { "n", "v" },
				desc = "Edit with Instructions",
			},
		},
		opts = {},
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
	},
	{
		"Bryley/neoai.nvim",
		dependencies = {
			"MunifTanjim/nui.nvim",
		},
		cmd = {
			"NeoAI",
			"NeoAIOpen",
			"NeoAIClose",
			"NeoAIToggle",
			"NeoAIContext",
			"NeoAIContextOpen",
			"NeoAIContextClose",
			"NeoAIInject",
			"NeoAIInjectCode",
			"NeoAIInjectContext",
			"NeoAIInjectContextCode",
			"NeoAIShortcut",
		},
		keys = {
			{ "<leader>as", desc = "Summarize Text" },
			{ "<leader>ag", desc = "Generate Git Message" },
		},
		opts = {},
		config = function()
			require("neoai").setup({
				-- Options go here
			})
		end,
	},
}
