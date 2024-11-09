local keymap = vim.keymap.set

-- keymap("n", "<C-l>", "<C-w>l")
-- keymap("n", "<C-h>", "<C-w>h")
-- keymap("n", "<C-j>", "<C-w>j")
-- keymap("n", "<C-k>", "<C-w>k")

keymap("t", "<C-h>", "<C-\\><C-n><C-w>h")
keymap("t", "<C-j>", "<C-\\><C-n><C-w>j")
keymap("t", "<C-k>", "<C-\\><C-n><C-w>k")
keymap("t", "<C-l>", "<C-\\><C-n><C-w>l")
keymap("t", "<C-n>", "<C-\\><C-n>")
keymap("n", "[e", "<cmd>cprevious<CR>")
keymap("n", "]e", "<cmd>cnext<CR>")

keymap("n", "<S-Up>", "<cmd>resize +2<CR>")
keymap("n", "<S-Down>", "<cmd>resize -2<CR>")
keymap("n", "<S-Left>", "<cmd>vertical resize -2<CR>")
keymap("n", "<S-Right>", "<cmd>vertical resize +2<CR>")

keymap("n", "vv", ":split<CR>", { silent = true })
keymap("n", "vs", ":vsplit<CR>", { silent = true })
keymap("n", "<leader>w", "<cmd>update!<cr>")

keymap("i", ",", ",<c-g>u")
keymap("i", ".", ".<c-g>u")
keymap("i", ";", ";<c-g>u")
keymap("i", "<C-h>", "<left>")
keymap("i", "<C-l>", "<right>")

keymap("n", "x", '"_x')
keymap("n", "dw", 'vb"_d')
keymap("n", "<leader>q", ":cclose<CR>")
