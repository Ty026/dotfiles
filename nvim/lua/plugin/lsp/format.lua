local M = {}

local function get_opts(name)
  local plugin = require("lazy.core.config").plugins[name]
  if not plugin then
    return {}
  end
  return require("lazy.core.plugin").values(plugin, "opts", false)
end

local function supports_format(client)
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities.documentFormattingProvider == false
  then
    return false
  end
  return client.supports_method("textDocument/formatting") or client.supports_method("textDocument/rangeFormatting")
end

local function get_formatters(bufnr)
  local ft = vim.bo[bufnr].filetype
  -- 获取当前文件类型的 null-ls 格式化器
  local null_ls_sources = {}
  if package.loaded["null-ls"] then
    null_ls_sources = require("null-ls.sources").get_available(ft, "NULL_LS_FORMATTING") or {}
  end

  local formatters = {
    active = {},
    available = {},
    null_ls = null_ls_sources,
  }

  -- 获取当前缓冲区的所有 LSP 客户端
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local null_ls_active = #null_ls_sources > 0

  for _, client in ipairs(clients) do
    if supports_format(client) then
      -- 如果 null-ls 有活动的格式化器，并且当前客户端是 null-ls，则将其视为 active
      -- 否则将其视为 available
      if client.name == "null-ls" then
        if null_ls_active then
          table.insert(formatters.active, client)
        else
          table.insert(formatters.available, client)
        end
      elseif not null_ls_active then
        table.insert(formatters.active, client)
      else
        table.insert(formatters.available, client)
      end
    end
  end

  return formatters
end

function M.format()
  local buf = vim.api.nvim_get_current_buf()
  local formatters = get_formatters(buf)
  local active_client_ids = vim.tbl_map(function(client)
    return client.id
  end, formatters.active)

  if vim.tbl_isempty(active_client_ids) then
    return
  end

  if M.format_notify then
    M.notify(formatters)
  end

  local format_options = get_opts("nvim-lspconfig").format or {}
  vim.lsp.buf.format(vim.tbl_deep_extend("force", {
    bufnr = buf,
    filter = function(client)
      return vim.tbl_contains(active_client_ids, client.id)
    end,
  }, format_options))
end

function M.on_attach(_, bufnr)
  vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("LspFormat." .. bufnr, {}),
    buffer = bufnr,
    callback = function()
      M.format()
    end,
  })
end

return M
