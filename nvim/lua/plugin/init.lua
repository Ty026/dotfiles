return {
  "nvim-lua/plenary.nvim",
  "MunifTanjim/nui.nvim",
  { "DaikyXendo/nvim-material-icon", config = true },
  { "nacro90/numb.nvim", event = "BufReadPre", config = true },

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "▏", repeat_linebreak = false },
      scope = { show_start = false },
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
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", mode = { "n", "v" } },
      { "<C-x>", mode = { "n", "v" } },
      { "g<C-a>", mode = { "v" } },
      { "g<C-x>", mode = { "v" } },
    },
    -- stylua: ignore
    config = function()
      vim.api.nvim_set_keymap("n", "<C-a>", require("dial.map").inc_normal(),
        { desc = "Increment", noremap = true, a = 12 })
      vim.api.nvim_set_keymap("n", "<C-x>", require("dial.map").dec_normal(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-a>", require("dial.map").inc_visual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "<C-x>", require("dial.map").dec_visual(), { desc = "Decrement", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-a>", require("dial.map").inc_gvisual(), { desc = "Increment", noremap = true })
      vim.api.nvim_set_keymap("v", "g<C-x>", require("dial.map").dec_gvisual(), { desc = "Decrement", noremap = true })
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
    event = "VeryLazy",
    opts = {},
  },
  {
    "numToStr/Comment.nvim",
    dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
    opts = {},
    config = function()
      require("Comment").setup({
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      })
    end,
  },
  -- {
  --   "folke/persistence.nvim",
  --   event = "BufReadPre",
  --   opts = {
  --     options = { "buffers", "curdir", "tabpages", "winsize", "help" },
  --   },
  --   keys = {
  --     {
  --       "<leader>qs",
  --       function()
  --         require("persistence").load()
  --       end,
  --       desc = "Restore Session",
  --     },
  --     {
  --       "<leader>ql",
  --       function()
  --         require("persistence").load({ last = true })
  --       end,
  --       desc = "Restore Last Session",
  --     },
  --     {
  --       "<leader>qd",
  --       function()
  --         require("persistence").stop()
  --       end,
  --       desc = "Don't Save Current Session",
  --     },
  --   },
  -- },
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
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local npairs = require("nvim-autopairs")
      npairs.setup({
        check_ts = true,
      })
    end,
  },
  {
    "smjonas/inc-rename.nvim",
    opts = { input_buffer_type = "dressing" },
  },
  {
    "abecodes/tabout.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
    config = true,
  },

  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle" },
    keys = {
      { "<leader>d", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    },
    opts = {
      disable_netrw = false,
      hijack_netrw = true,
      respect_buf_cwd = true,
      view = {
        number = true,
        relativenumber = true,
      },
      filters = {
        custom = { ".git" },
        dotfiles = false,
      },
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = true,
      },
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    },
  },
  {
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
        { "<leader>t", "<cmd>TodoTrouble<cr>", desc = "ToDo (Trouble)" },
        { "<leader>T", "<cmd>TodoTelescope<cr>", desc = "ToDo" },
      },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
      { [[<C-\>]] },
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
  },
  {
    "xiyaowong/nvim-transparent",
    cmd = { "TransparentEnable", "TransparentDisable", "TransparentToggle" },
    opts = {
      extra_groups = { -- table/string: additional groups that should be cleared
        -- In particular, when you set it to 'all', that means all available groups

        -- example of akinsho/nvim-bufferline.lua
        "BufferLineTabClose",
        "BufferlineBufferSelected",
        "BufferLineFill",
        "BufferLineBackground",
        "BufferLineSeparator",
        "BufferLineIndicatorSelected",
      },
      exclude_groups = {}, -- table: groups you don't want to clear
    },
    config = function(_, opts)
      require("transparent").setup(opts)
    end,
  },
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },
}
