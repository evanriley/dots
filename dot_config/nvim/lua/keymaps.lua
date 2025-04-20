local keymap = vim.keymap.set

local split_sensibly = function()
  if vim.api.nvim_win_get_width(0) > math.floor(vim.api.nvim_win_get_height(0) * 2.3) then
    vim.cmd("vs")
  else
    vim.cmd("split")
  end
end

-- [[ Basic Keymaps ]]
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})

-- File Finder keymaps
keymap("n", "<leader>ff", function()
  require("mini.pick").builtin.files()
end)
keymap("n", "<leader>fr", function()
  require("mini.pick").builtin.resume()
end)
keymap("n", "<leader>fg", function()
  require("mini.pick").builtin.grep_live()
end)
keymap("n", "<leader>fG", function()
  local wrd = vim.fn.expand("<cword>")
  require("mini.pick").builtin.grep({ pattern = wrd })
end)
keymap("n", "<leader>fh", function()
  require("mini.pick").builtin.help()
end)
keymap("n", "<leader>fl", function()
  require("mini.pick").builtin.hl_groups()
end)
keymap("n", "<leader>bb", function()
  require("mini.pick").builtin.buffers()
end)

-- [[ Oil Keymaps]]
keymap("n", "-", "<cmd>Oil<CR>")

-- [[ Sessions Keymaps ]]
keymap("n", "<leader>ss", function()
  vim.cmd("wa")
  require("mini.sessions").write()
  require("mini.sessions").select()
end)

keymap("n", "<leader>sw", function()
  local cwd = vim.fn.getcwd()
  local last_folder = cwd:match("([^/]+)$")
  require("mini.sessions").write(last_folder)
end)

keymap("n", "<leader>sf", function()
  vim.cmd("wa")
  require("mini.sessions").select()
end)

-- [[ Buffer Keymaps ]]
keymap("n", "<leader>bd", "<cmd>bd<cr>")
keymap("n", "<leader>bq", "<cmd>%bd|e<cr>")
keymap("n", "<S-l>", "<cmd>bnext<cr>")
keymap("n", "<S-h>", "<cmd>bprevious<cr>")
-- Format Buffer (with or without LSP)
if vim.tbl_isempty(vim.lsp.get_clients()) then
  keymap("n", "<leader>bf", function()
    vim.lsp.buf.format()
  end)
else
  keymap("n", "<leader>bf", "gg=G<C-o>")
end

-- [[ Git Keymaps ]]
keymap("n", "<leader>gb", function()
  require("mini.extra").pickers.git_commits({ path = vim.fn.expand("%:p") })
end)
keymap("n", "<leader>gl", function()
  split_sensibly()
  vim.cmd("terminal lazygit")
end)
keymap("n", "<leader>gp", "<cmd>:Git pull<cr>")
keymap("n", "<leader>gs", "<cmd>:Git push<cr>")
keymap("n", "<leader>ga", "<cmd>:Git add .<cr>")
keymap("n", "<leader>gh", function()
  require("mini.git").show_range_history()
end)
keymap("n", "<leader>gx", function()
  require("mini.git").show_at_cursor()
end)

-- [[ Completion Keymaps ]]
local imap_expr = function(lhs, rhs)
  vim.keymap.set("i", lhs, rhs, { expr = true })
end
imap_expr("<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]])
imap_expr("<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]])

-- [[ LSP Keymaps ]]
keymap("n", "<leader>gd", function()
  vim.lsp.buf.definition()
end)
keymap("n", "K", function()
  vim.lsp.buf.hover()
end)
keymap("n", "<leader>ls", "<cmd>Pick lsp scope='document_symbol'<cr>")
keymap("n", "<leader>gr", function()
  vim.lsp.buf.rename()
end)
keymap("n", "<leader>ca", function()
  vim.lsp.buf.code_action()
end)
keymap("n", "<leader>le", function()
  require("mini.extra").pickers.diagnostic({ scope = "current" })
end)
keymap("n", "<leader>lf", function()
  vim.diagnostic.setqflist({ open = true })
end)
keymap("n", "<leader>qj", "<cmd>cnext<CR>zz")
keymap("n", "<leader>qk", "<cmd>cprev<CR>zz")

-- [[ UI Keymaps ]]
---- Window Navigation
keymap("n", "<C-l>", "<cmd>wincmd l<cr>")
keymap("n", "<C-k>", "<cmd>wincmd k<cr>")
keymap("n", "<C-j>", "<cmd>wincmd j<cr>")
keymap("n", "<C-h>", "<cmd>wincmd h<cr>")
