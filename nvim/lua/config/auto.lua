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

vim.api.nvim_create_autocmd("FocusGained", { command = "checktime" })

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

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
    "chatgpt-input",
    "markdown",
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

local months =
  { Jan = 1, Feb = 2, Mar = 3, Apr = 4, May = 5, Jun = 6, Jul = 7, Aug = 8, Sep = 9, Oct = 10, Nov = 11, Dec = 12 }
local function date_to_timestamp(date_str)
  local month, day = date_str:match("(%a+)%s+(%d+)%s+(%d+)")
  if not (month and day) then
    return nil
  end
  month = months[month]
  return os.time({ year = 2024, month = month, day = day })
end

vim.api.nvim_create_user_command("BuildCppAndRun", function()
  local function check_compile_errors()
    local qf_list = vim.fn.getqflist()
    for _, error_item in ipairs(qf_list) do
      if error_item.valid == 1 and string.find(error_item.text, "error") then
        return true
      end
    end
    return false
  end
  local saved_directory = vim.fn.getcwd()
  vim.bo.makeprg = "cmake --build build"
  vim.opt.cmdheight = 0
  vim.cmd("make")
  vim.cmd("cd " .. saved_directory)
  if check_compile_errors() == false then
    local cmd = "ls -lt bin"
    local handle = io.popen(cmd)
    if handle == nil then
      return
    end
    local result = handle:read("*a")
    handle:close()
    local files = {}
    for line in result:gmatch("[^\r\n]+") do
      local date_str, file_name = line:match("%s+(%a+%s+%d+%s+%d+:%d+)%s+(.+)$")
      if date_str and file_name then
        local timestamp = date_to_timestamp(date_str)
        table.insert(files, { mod_time = timestamp, file_name = file_name })
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
      executable = "!./bin/app"
    end
    vim.cmd(executable)
  end
end, {})
