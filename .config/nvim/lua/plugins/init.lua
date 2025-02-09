-- plugins/init.lua
return {
	-- Core plugins that other plugins might depend on
	{
		"folke/lazy.nvim",
		version = "*",
	},
	{
		"nvim-lua/plenary.nvim",
		lazy = true,
	},
	{
		"folke/neodev.nvim", -- Neovim lua API documentation
		opts = {},
	},

	-- Colorscheme
	{
		"f-person/auto-dark-mode.nvim",
		lazy = false,
		opts = {
			update_interval = 3000,
			set_dark_mode = function()
				vim.api.nvim_set_option_value("background", "dark", {})
			end,
			set_light_mode = function()
				vim.api.nvim_set_option_value("background", "light", {})
			end,
		},
	},
	{
		"loganswartz/selenized.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.selenized_variant = "bw"
			vim.cmd([[colorscheme selenized]])
		end,
	},
}
