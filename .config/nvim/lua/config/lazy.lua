-- lazy.lua
local opts = {
	defaults = {
		lazy = true,
	},
	install = {
		colorscheme = { "selenized" },
	},
	performance = {
		cache = {
			enabled = true,
		},
		reset_packpath = true,
		rtp = {
			reset = true,
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	change_detection = {
		notify = false,
	},
}

require("lazy").setup("plugins", opts)
