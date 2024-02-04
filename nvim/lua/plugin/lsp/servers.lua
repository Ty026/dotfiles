local M = {}

local utils = require("plugin.lsp.utils")

local icons = require("config.icons")

local function lsp_init()
	local signs = {
		{ name = "DiagnosticSignError", text = icons.diagnostics.Error },
		{ name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
		{ name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
		{ name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
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
		},
	}
	vim.diagnostic.config(config.diagnostic)
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

function M.setup(_, opts)
	utils.on_attach(function(client, buf)
		require("plugin.lsp.format").on_attach(client, buf)
		require("plugin.lsp.keymaps").on_attach(client, buf)
	end)
	lsp_init()

	local capabilities = utils.capabilities()
	local servers = opts.servers

	local function setup(server)
		local server_opts = vim.tbl_deep_extend("force", {
			capabilities = capabilities,
		}, servers[server] or {})

		if opts.setup[server] then
			if opts.setup[server](server, server_opts) then
				return
			end
		elseif opts.setup["*"] then
			if opts.setup["*"](server, server_opts) then
				return
			end
		end
		require("lspconfig")[server].setup(server_opts)
	end

	local mason_ok, mason = pcall(require, "mason-lspconfig")
	local all_mslp_servers = {}
	if mason_ok then
		all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
	end
	local ensure_installed = {}
	for server, opt in pairs(opts.servers) do
		if vim.tbl_contains(all_mslp_servers, server) and (type(opt) == "table" and opt.mason ~= false) then
			ensure_installed[#ensure_installed + 1] = server
		else
			setup(server)
		end
	end

	if mason_ok then
		mason.setup({ ensure_installed = ensure_installed })
		mason.setup_handlers({ setup })
	end
end

return M
