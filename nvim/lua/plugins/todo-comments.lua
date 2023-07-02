return {
    {
      "folke/todo-comments.nvim",
      cmd = { "TodoTrouble", "TodoTelescope" },
      event = "BufReadPost",
      config = true,
      -- stylua: ignore
      keys = {
        { "]t", function() require("todo-comments").jump_next() end, desc = "Next ToDo" },
        { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous ToDo" },
        { "<leader>ct", "<cmd>TodoTelescope<cr>", desc = "ToDo (Trouble)" },
      },
    },
  }