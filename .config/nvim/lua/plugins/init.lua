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
		"loganswartz/selenized.nvim",
		dependencies = {
			"rktjmp/lush.nvim",
		},
		lazy = false,
		priority = 1000,
		config = function()
			vim.g.selenized_variant = "normal"
			vim.api.nvim_set_option_value("background", "dark", {})
			vim.cmd([[colorscheme selenized]])
		end,
	},
}
