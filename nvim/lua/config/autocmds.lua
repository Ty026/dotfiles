local function augroup(name)
	return vim.api.nvim_create_augroup("mnv_" .. name, { clear = true })
end
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		local lcount = vim.api.nvim_buf_line_count(0)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

-- Auto toggle hlsearch
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
local function toggle_hlsearch(char)
	if vim.fn.mode() == "n" then
		local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
		local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))

		if vim.opt.hlsearch:get() ~= new_hlsearch then
			vim.opt.hlsearch = new_hlsearch
		end
	end
end
vim.on_key(toggle_hlsearch, ns)

vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"OverseerForm",
		"OverseerList",
		"checkhealth",
		"floggraph",
		"fugitive",
		"git",
		"help",
		"lspinfo",
		"man",
		"qf",
		"query",
		"spectre_panel",
		"startuptime",
		"toggleterm",
		"tsplayground",
		"vim",
		"neoai-input",
		"neoai-output",
		"notify",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

vim.api.nvim_set_hl(0, "TerminalCursorShape", { underline = true })
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		vim.cmd([[setlocal winhighlight=TermCursor:TerminalCursorShape]])
	end,
})

vim.api.nvim_create_autocmd("CursorHold", {
	callback = function()
		if require("plugin.lsp.utils").show_diagnostics() then
			vim.schedule(vim.diagnostic.open_float)
		end
	end,
})
