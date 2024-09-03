return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx" })
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "prettierd" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.prettierd)
    end,
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = {
            "html",
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
        },
        emmet_ls = {
          init_options = {
            html = {
              options = { ["bem.enabled"] = true },
            },
          },
        },
        cssls = {},
        tailwindcss = { filetypes_exclude = { "markdown" } },
      },
    },
  },
}
