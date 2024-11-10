return {
  "vim-test/vim-test",
  dependencies = {
    "preservim/vimux",
  },
  keys = {
    { "<leader>tc", "<cmd>w|TestClass<cr>", desc = "Class" },
    { "<leader>tf", "<cmd>w|TestFile<cr>", desc = "File" },
    { "<leader>tl", "<cmd>w|TestLast<cr>", desc = "Last" },
    { "<leader>tn", "<cmd>w|TestNearest<cr>", desc = "Nearest" },
    { "<leader>ts", "<cmd>w|TestSuite<cr>", desc = "Suite" },
    { "<leader>tv", "<cmd>w|TestVisit<cr>", desc = "Visit" },
  },
  config = function()
    vim.cmd("let test#strategy = 'vimux'")
    vim.cmd("let test#python#runner= 'pyunit'")
  end,
}
