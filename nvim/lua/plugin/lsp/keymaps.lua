local M = {}

function M.diagnostic_goto(next, severity)
	local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
	severity = severity and vim.diagnostic.severity[severity] or nil
	return function()
		go({ severity = severity })
	end
end

function M.on_attach(client, buf)
	local telescope = require("telescope.builtin")

	local function has(capability)
		return client.server_capabilities[capability .. "Provider"]
	end

	local function map(lhs, rhs, opts)
		opts = opts or {}
		if opts.has and not has(opts.has) then
			return
		end
		vim.keymap.set(
			opts.mode or "n",
			lhs,
			type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs,
			{ silent = true, buffer = buf, expr = opts.expr, desc = opts.desc }
		)
	end

	local function goto_definition()
		telescope.lsp_definitions({ reuse_win = true })
	end

	local function goto_implementation()
		print(telescope.lsp_implementations)
		telescope.lsp_implementations({ reuse_win = true })
	end

	local useIncRename = true
	if client.name == "tsserver" then
		useIncRename = false
	end

	local function rename()
		local ok = pcall(require, "inc_rename")
		if ok and useIncRename then
			return ":IncRename " .. vim.fn.expand("<cword>")
		else
			vim.lsp.buf.rename()
		end
	end

	if client.name == "typescript-tools" then
		map("<leader>r", "Lspsaga rename", { desc = "Rename", has = "rename" })
	else
		map("<leader>r", rename, { expr = true, desc = "Rename", has = "rename" })
	end

	map("K", "Lspsaga hover_doc", { desc = "Hover" })
	map("gK", vim.lsp.buf.signature_help, { desc = "Signature Help", has = "signatureHelp" })
	map("gr", "Telescope lsp_references", { desc = "References" })
	map("gd", goto_definition, { desc = "Goto Definition" })
	map("gD", "Lspsaga peek_definition", { desc = "Peek Definition" })
	map("gi", goto_implementation, { desc = "Goto Implementation" })
	map("<leader>ca", "Lspsaga code_action", { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })
	map("]d", M.diagnostic_goto(true), { desc = "Next Diagnostic" })
	map("[d", M.diagnostic_goto(false), { desc = "Prev Diagnostic" })
	map("]e", M.diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
	map("[e", M.diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
	map("]w", M.diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
	map("[w", M.diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
end

return M
