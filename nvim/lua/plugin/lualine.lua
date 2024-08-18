local icons = require("config.icon")
local components = {
  spaces = {
    function()
      local shiftwidth = vim.api.nvim_buf_get_option(0, "shiftwidth")
      return icons.ui.Tab .. " " .. shiftwidth
    end,
    padding = 1,
  },
  git_repo = {
    function()
      if
        #vim.api.nvim_list_tabpages() > 1
        and vim.fn.trim(vim.fn.system("git rev-parse --is-inside-work-tree")) == "true"
      then
        return vim.fn.trim(vim.fn.system("basename `git rev-parse --show-toplevel`"))
      end
      return ""
    end,
  },
  separator = {
    function()
      return "%="
    end,
  },
  diff = {
    "diff",
    colored = false,
  },
  diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    diagnostics_color = {
      error = "DiagnosticError",
      warn = "DiagnosticWarn",
      info = "DiagnosticInfo",
      hint = "DiagnosticHint",
    },
    colored = true,
  },
}

local M = {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = {},
          section_separators = {},
          disabled_filetypes = {
            statusline = { "alpha", "lazy" },
            winbar = { "help", "alpha", "lazy" },
          },
          always_divide_middle = true,
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { components.git_repo, "branch" },
          lualine_c = {
            components.diff,
            components.diagnostics,
            components.separator,
          },
          lualine_x = { "filename", "encoding", "filetype", "progress" },
          lualine_y = {},
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        extensions = { "nvim-tree", "toggleterm", "quickfix" },
      })
    end,
  },
}

return M
