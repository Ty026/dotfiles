return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "python", "rst" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      table.insert(opts.sources, nls.builtins.formatting.black)
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "black", "debugpy", "ruff" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruff_lsp = {},
        pyright = {
          settings = {
            python = {
              venvPath = vim.fn.expand("~/.cache/pypoetry/virtualenvs"), -- 设置默认路径，便于管理
              pythonPath = vim.fn.systemlist("poetry env info --path")[1] .. "/bin/python", -- 动态获取当前项目的 Python 路径
              analysis = {
                typeCheckingMode = "off",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs/stubs",
              },
            },
          },
        },
      },
      setup = {
        ruff_lsp = function()
          require("plugin.lsp.server").on_attach(function(client, _)
            if client.name == "ruff_lsp" then
              client.server_capabilities.hoverProvider = false
            end
          end)
        end,
        pyright = function(_, _)
          require("plugin.lsp.server").on_attach(function(client, bufnr)
            local map = function(mode, lhs, rhs, desc)
              if desc then
                desc = desc
              end
              vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
            end
            if client.name == "pyright" then
              map("n", "<leader>lo", "<cmd>PyrightOrganizeImports<cr>", "Organize Imports")
            end
          end)
        end,
      },
    },
  },
  {
    "microsoft/python-type-stubs",
    cond = false,
  },
}
