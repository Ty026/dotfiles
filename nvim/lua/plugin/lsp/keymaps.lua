local M = {}

local function rename()
	local ok = pcall(require, "inc_rename")
	if ok then
		return ":IncRename " .. vim.fn.expand("<cword>")
	else
		vim.lsp.buf.rename()
	end
end

function M.on_attach(client, buf)
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
	map("K", "Lspsaga hover_doc", { desc = "Hover" })
	map("<leader>r", rename, { expr = true, desc = "Rename", has = "rename" })
end

return M
