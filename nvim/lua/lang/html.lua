return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "html", "css" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          filetypes = {
            "html",
            -- "javascript",
            -- "javascriptreact",
            -- "javascript.jsx",
            -- "typescript",
            -- "typescriptreact",
            -- "typescript.tsx",
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
