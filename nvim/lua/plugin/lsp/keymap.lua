local M = {}

local function diagnostic_goto(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
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
    vim.keymap.set(opts.mode or "n", lhs, type(rhs) == "string" and ("<cmd>%s<cr>"):format(rhs) or rhs, {
      silent = true,
      buffer = buf,
      expr = opts.expr,
      desc = opts.desc,
    })
  end
  -- map("<C-k>", vim.lsp.buf.signature_help, {
  --   desc = "Signature Help",
  --   has = "signatureHelp",
  --   mode = { "n", "i" },
  -- })
  map("gr", "Telescope lsp_references", { desc = "References" })
  map("gD", "Lspsaga peek_definition", { desc = "Peek Definition" })
  map("gd", "Lspsaga goto_definition", { desc = "Goto Definition" })
  map("gI", function()
    require("telescope.builtin").lsp_implementations({ reuse_win = true })
  end, { desc = "Goto Implementation" })
  map("]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
  map("[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
  map("]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
  map("[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
  map("]w", diagnostic_goto(true, "WARNING"), { desc = "Next Warning" })
  map("[w", diagnostic_goto(false, "WARNING"), { desc = "Prev Warning" })
  map("<C-y>", "Lspsaga diagnostic_jump_next", { desc = "Diagnostic" })
  map("<leader>ca", "Lspsaga code_action", { desc = "Code Action", mode = { "n", "v" }, has = "codeAction" })

  local function rename()
    local ok = pcall(require, "inc_rename")
    if ok then
      return ":IncRename " .. vim.fn.expand("<cword>")
    else
      vim.lsp.buf.rename()
    end
  end
  map("<leader>r", rename, { expr = true, desc = "Rename", has = "rename" })
end
return M
