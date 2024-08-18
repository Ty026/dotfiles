function telescope_buffer_dir()
  return vim.fn.expand("%:p:h")
end

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
  },

  keys = {
    {
      "<leader>f",
      "<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files theme=ivy<CR>",
    },
    {
      "<leader>e",
      function()
        require("telescope").extensions.file_browser.file_browser({
          cwd = telescope_buffer_dir(),
          respect_git_ignore = false,
          hidden = true,
          grouped = true,
        })
      end,
      desc = "Open file browser",
    },
    { "<leader>l", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Live Grep" },
    { "<leader>b", "<cmd>Telescope buffers<cr>", desc = "" },
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
      "build",
      "node_modules",
      ".cache",
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
  end,
}
