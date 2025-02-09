-- keymaps.lua
local map = vim.keymap.set

-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate window right" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

-- Buffer navigation
map("n", "<S-h>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<leader>bd", ":bdelete<CR>", { desc = "Delete buffer" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear hlsearch and escape" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move Lines
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move line down" })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- Save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- Better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Diagnostic keymaps
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Float diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic setloclist" })

-- LSP keymaps (will only be set when LSP connects)
local function lsp_keymaps(bufnr)
	local opts = { buffer = bufnr }
	map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
	map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
	map("n", "K", vim.lsp.buf.hover, { desc = "Hover", buffer = bufnr })
	map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = bufnr })
	map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })
	map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder", buffer = bufnr })
	map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder", buffer = bufnr })
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, { desc = "List workspace folders", buffer = bufnr })
	map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition", buffer = bufnr })
	map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename", buffer = bufnr })
	map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
	map("n", "gr", vim.lsp.buf.references, { desc = "References", buffer = bufnr })
	map("n", "<leader>lf", function()
		vim.lsp.buf.format({ async = true })
	end, { desc = "Format buffer", buffer = bufnr })
end

-- Export lsp_keymaps for use in LSP config
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(args)
		lsp_keymaps(args.buf)
	end,
})

-- Telescope mappings
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Recent Files" })
map("n", "<leader>fc", "<cmd>Telescope commands<cr>", { desc = "Commands" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })
map("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "Diagnostics" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })

-- Improved paste
map("x", "p", [["_dP]])

-- Stay in indent mode
map("v", "<", "<gv", { desc = "Indent left and stay in visual mode" })
map("v", ">", ">gv", { desc = "Indent right and stay in visual mode" })

-- Session management
map("n", "<leader>ss", function()
	require("persistence").load()
end, { desc = "Restore Session" })
map("n", "<leader>sl", function()
	require("persistence").load({ last = true })
end, { desc = "Restore Last Session" })
map("n", "<leader>sd", function()
	require("persistence").stop()
end, { desc = "Don't Save Current Session" })

-- Neorg mappings
map("n", "<leader>nn", "<cmd>Neorg workspace notes<cr>", { desc = "Open Notes" })
map("n", "<leader>ns", "<cmd>Neorg workspace school<cr>", { desc = "Open School Notes" })
map("n", "<leader>ni", "<cmd>Neorg index<cr>", { desc = "Open Index" })
map("n", "<leader>nr", "<cmd>Neorg return<cr>", { desc = "Return to Last Workspace" })

-- Open parent directory with -
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
