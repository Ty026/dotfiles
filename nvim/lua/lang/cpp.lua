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
    dependencies = { "p00f/clangd_extensions.nvim" },
    opts = {
      servers = {
        clangd = {},
      },
      setup = {
        clangd = function(_, opts)
          require("clangd_extensions").setup({
            server = {
              root_dir = function(...)
                return require("lspconfig.util").root_pattern(
                  "compile_commands.json",
                  "compile_flags.txt",
                  "configure.ac",
                  ".git"
                )(...)
              end,
              capabilities = {
                offsetEncoding = { "utf-16" },
              },
              cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--header-insertion=iwyu",
                "--completion-style=detailed",
                "--function-arg-placeholders",
                "--fallback-style=llvm",
              },
              init_options = {
                usePlaceholders = true,
                completeUnimported = true,
                clangdFileStatus = true,
              },
            },
            extensions = opts.extensions,
          })
          require("plugin.lsp.server").on_attach(function(client, bufnr)
            if client.name == "clangd" then
              vim.keymap.set("n", "<C-g>", "<cmd>ClangdSwitchSourceHeader<cr>", { buffer = bufnr })
              vim.keymap.set("n", "<S-b>", "<cmd>BuildCppAndRun<cr>", { buffer = bufnr })
            end
          end)
        end,
      },
    },
  },
}
