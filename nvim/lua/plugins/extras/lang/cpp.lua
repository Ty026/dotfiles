local function get_codelldb()
    local mason_registry = require "mason-registry"
    local codelldb = mason_registry.get_package "codelldb"
    local extension_path = codelldb:get_install_path() .. "/extension/"
    local codelldb_path = extension_path .. "adapter/codelldb"
    local liblldb_path = extension_path .. "lldb/lib/liblldb.so"
    return codelldb_path, liblldb_path
  end
  
  return {
    {
      "nvim-treesitter/nvim-treesitter",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { "c", "cpp" })
      end,
    },
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        vim.list_extend(opts.ensure_installed, { "codelldb" })
      end,
    },
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          clangd = {},
        },
        setup = {
            clangd = function(_, opts)
                local lsp_utils = require "plugins.lsp.utils"
                lsp_utils.on_attach(function(client, buffer)
                  if client.name == "clangd" then
                    vim.keymap.set("n", "<C-g>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = buffer })
                    vim.keymap.set("n", "<C-b>", "<cmd>CMakeBuild<cr>", {buffer = buffer}) -- see config/autocmds.lua
                  end
                end)
            end},
      },

    },
    {
      "mfussenegger/nvim-dap",
      opts = {
        setup = {
          codelldb = function()
            local codelldb_path, _ = get_codelldb()
            local dap = require "dap"
            dap.adapters.codelldb = {
              type = "server",
              port = "${port}",
              executable = {
                command = codelldb_path,
                args = { "--port", "${port}" },
  
                -- On windows you may have to uncomment this:
                -- detached = false,
              },
            }
            dap.configurations.cpp = {
              {
                name = "Launch file",
                type = "codelldb",
                request = "launch",
                program = function()
                  return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
              },
            }
  
            dap.configurations.c = dap.configurations.cpp
            dap.configurations.rust = dap.configurations.cpp
          end,
        },
      },
    },
  }