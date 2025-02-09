-- options.lua
local opt = vim.opt

-- Performance
opt.shell = "nu" -- Faster shell
opt.shadafile = "NONE" -- Don't store shada file

-- UI
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.showmode = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.cmdheight = 1
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.splitbelow = true
opt.splitright = true
opt.conceallevel = 2

-- Behavior
opt.hidden = true
opt.errorbells = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("data") .. "/undodir"
opt.undofile = true
opt.updatetime = 50
opt.timeoutlen = 300
opt.completeopt = "menuone,noselect"

-- Indentation
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.wrap = false

-- Search
opt.hlsearch = false
opt.incsearch = true
opt.ignorecase = true
opt.smartcase = true

-- Mouse
opt.mouse = "a"

-- Clipboard
opt.clipboard = "unnamedplus"

-- Window
opt.winblend = 0
opt.pumblend = 0
opt.pumheight = 10

-- Fill chars
opt.fillchars = {
	foldopen = "▼", -- Triangle pointing down for open folds
	foldclose = "▶", -- Triangle pointing right for closed folds
	fold = "·", -- Dots for folded lines
	foldsep = " ", -- Space for fold separator
	diff = "╱", -- Diagonal line for diffs
	eob = " ", -- Empty space for end of buffer
	msgsep = "‾", -- Message separator
	horiz = "━", -- Horizontal split
	horizup = "┻", -- Horizontal split (up)
	horizdown = "┳", -- Horizontal split (down)
	vert = "┃", -- Vertical split
	vertleft = "┫", -- Vertical split (left)
	vertright = "┣", -- Vertical split (right)
	verthoriz = "╋", -- Intersection
}

-- Fold
opt.foldlevel = 99
opt.foldlevelstart = 99
opt.foldenable = true
