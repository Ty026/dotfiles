return {
	{
		"stevearc/overseer.nvim",
		cmd = "Overseer",
		keys = {
			{ "<leader>tR", "<cmd>OverseerRunCmd<cr>", desc = "Run Command" },
			{ "<leader>ta", "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },
			{ "<leader>tb", "<cmd>OverseerBuild<cr>", desc = "Build" },
			{ "<leader>tc", "<cmd>OverseerClose<cr>", desc = "Close" },
			{ "<leader>td", "<cmd>OverseerDeleteBundle<cr>", desc = "Delete Bundle" },
			{ "<leader>tl", "<cmd>OverseerLoadBundle<cr>", desc = "Load Bundle" },
			{ "<leader>to", "<cmd>OverseerOpen<cr>", desc = "Open" },
			{ "<leader>tq", "<cmd>OverseerQuickAction<cr>", desc = "Quick Action" },
			{ "<leader>tr", "<cmd>OverseerRun<cr>", desc = "Run" },
			{ "<leader>ts", "<cmd>OverseerSaveBundle<cr>", desc = "Save Bundle" },
			{ "<leader>tt", "<cmd>OverseerToggle<cr>", desc = "Toggle" },
		},
		config = function(_, opts)
			local overseer = require("overseer")
			overseer.setup({
				task_list = {
					direction = "bottom",
					min_height = 15,
				},
				templates = { "builtin", "cpp_build", "cmake" },
			})
		end,
	},
}
