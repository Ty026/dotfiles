return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "javascript", "typescript", "tsx" })
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      servers = {
        tsserver = {},
      },
      setup = {
        tsserver = function(_, opts)
          local lsp_utils = require "plugins.lsp.utils"
          lsp_utils.on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
              vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
            end
          end)
          require("typescript").setup { server = opts }
          return true
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = { "mxsdev/nvim-dap-vscode-js" },
    opts = {
      -- setup = {
      --   debugpy = function(_, _)
      --     require("dap-vscode-js").setup("python", {})
      --     table.insert(require("dap").configurations.python, {
      --       type = "python",
      --       request = "attach",
      --       connect = {
      --         port = 5678,
      --         host = "127.0.0.1",
      --       },
      --       mode = "remote",
      --       name = "container attach debug",
      --       cwd = vim.fn.getcwd(),
      --       pathmappings = {
      --         {
      --           localroot = function()
      --             return vim.fn.input("local code folder > ", vim.fn.getcwd(), "file")
      --           end,
      --           remoteroot = function()
      --             return vim.fn.input("container code folder > ", "/", "file")
      --           end,
      --         },
      --       },
      --     })
      --   end,
      -- },
    },
  },
}