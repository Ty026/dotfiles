return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "glsl" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "glsl_analyzer" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        glsl_analyzer = {},
      },
      setup = {},
    },
  },
}
