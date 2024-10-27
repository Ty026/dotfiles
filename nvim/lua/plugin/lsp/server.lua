local M = {}

local icons = require("config.icon")

local get_capabilities = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return require("cmp_nvim_lsp").default_capabilities(capabilities)
end

local function lsp_init()
  local signs = {
    { name = "DiagnosticSignError", text = icons.diagnostics.Error },
    { name = "DiagnosticSignWarn",  text = icons.diagnostics.Warning },
    { name = "DiagnosticSignHint",  text = icons.diagnostics.Hint },
    { name = "DiagnosticSignInfo",  text = icons.diagnostics.Info },
  }
  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
  end

  local config = {
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
    },

    diagnostic = {
      -- virtual_text = false,
      -- virtual_text = { spacing = 4, prefix = "●" },
      virtual_text = {
        severity = {
          min = vim.diagnostic.severity.ERROR,
        },
      },
      signs = {
        active = signs,
      },
      underline = false,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
      -- virtual_lines = true,
    },
  }

  vim.diagnostic.config(config.diagnostic)

  -- Hover configuration
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

  -- Signature help configuration
  -- vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end


function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

M.setup = function(_, opts)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      require("plugin.lsp.format").on_attach(client, args.buf)
      require("plugin.lsp.keymap").on_attach(client, args.buf)
    end,
  })

  lsp_init()

  local servers = opts.servers or {}
  local capabilities = get_capabilities()

  -- 定义配置每个 LSP 服务器的方法
  local function setup_server(server, server_opts)
    require("lspconfig")[server].setup(server_opts)
  end

  -- 处理每个服务器的配置
  local function process_server(server)
    local server_opts = vim.tbl_deep_extend("force", { capabilities = capabilities }, servers[server] or {})

    -- 如果有特定服务器的自定义设置，优先调用
    if opts.setup[server] and opts.setup[server](server, server_opts) then
      return
    end

    -- 如果有全局的自定义设置，调用并决定是否继续
    if opts.setup["*"] and opts.setup["*"](server, server_opts) then
      return
    end

    -- 最后，使用默认的 setup 函数进行配置
    setup_server(server, server_opts)
  end

  -- 检查是否安装了 Mason 并获取可用服务器列表
  local has_mason, mlsp = pcall(require, "mason-lspconfig")
  local installed_servers = has_mason and vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      or {}

  -- 收集需要通过 Mason 安装的服务器
  local ensure_installed = {}

  for server, server_opts in pairs(servers) do
    server_opts = server_opts == true and {} or server_opts
    if vim.tbl_contains(installed_servers, server) and (type(server_opts) == "table" and server_opts.mason ~= false) then
      table.insert(ensure_installed, server)
    else
      process_server(server)
    end
  end


  -- 如果使用 Mason，则安装和设置所有未安装的服务器
  if has_mason then
    mlsp.setup({ ensure_installed = ensure_installed })
    mlsp.setup_handlers({ process_server })
  end
end

return M
