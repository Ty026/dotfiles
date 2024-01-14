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

vim.api.nvim_create_user_command("BuildCppAndRun", function()
	local function check_compile_errors()
		local qf_list = vim.fn.getqflist()
		for _, error_item in ipairs(qf_list) do
			if error_item.valid == 1 then
				return true
			end
		end
		return false
	end
	vim.bo.makeprg = "cmake -Bbuild -GNinja && cmake --build build"
	vim.opt.cmdheight = 0
	vim.cmd("make")
	if check_compile_errors() == false then
		local cmd = "ls -lt bin"
		local handle = io.popen(cmd)
		local result = handle:read("*a")
		handle:close()
		local files = {}
		for line in result:gmatch("[^\r\n]+") do
			local _, _, mod_time, file_name = line:find("(%d%d:%d%d)%s+(.*)")
			if mod_time and file_name then
				table.insert(files, { mod_time = mod_time, file_name = file_name })
			end
		end
		table.sort(files, function(a, b)
			return a.mod_time > b.mod_time
		end)
		local first_file = files[1].file_name
		local has_extension = string.find(first_file, "%.[^.]+$")

		local executable = ""
		if not has_extension and first_file ~= nil then
			executable = "!./bin/" .. first_file
		else
			executable = "!./bin/game"
		end
		vim.cmd(executable)
	end
end, {})
