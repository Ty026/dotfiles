return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf" },
      "j-hui/fidget.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      setup = {},
    },
    config = function(plugin, opts)
      require("plugin.lsp.server").setup(plugin, opts)
    end,
  },
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    cmd = "Mason",
    opts = {
      ensure_installed = { "shfmt" },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          nls.builtins.formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci", "-bn" },
          }),
        },
      }
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "VeryLazy",
    opts = {
      symbol_in_winbar = {
        enable = false,
      },
      lightbulb = {
        enable = false,
      },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = { "Trouble" },
    opts = { use_diagnostic_signs = true, focus = true },
    keys = {
      { "<leader>h", "<cmd>Trouble diagnostics<cr>", desc = "Document Diagnostics" },
    },
  },
}
