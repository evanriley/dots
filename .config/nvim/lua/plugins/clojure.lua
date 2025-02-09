-- plugins/clojure.lua
return {
	-- Clojure REPL integration
	{
		"Olical/conjure",
		ft = { "clojure" },
		init = function()
			-- Configure Conjure before it loads
			vim.g["conjure#log#wrap"] = true
			vim.g["conjure#log#fold#enabled"] = true
			vim.g["conjure#log#botright"] = true
			vim.g["conjure#client#clojure#nrepl#eval#auto_require"] = false
			vim.g["conjure#client#clojure#nrepl#connection#auto_repl#enabled"] = false
			-- Disable default mappings if you want to customize them
			vim.g["conjure#mapping#doc_word"] = false -- Disable K mapping as we use it for LSP
		end,
		config = function(_, _)
			-- Add any additional configuration here
			require("conjure.main").main()
			require("conjure.mapping")["on-filetype"]()
		end,
	},

	-- Auto-close and auto-rename tags
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			check_ts = true,
			ts_config = {
				clojure = { "list", "vector", "map" }, -- don't add pairs in clojure treesitter nodes
			},
		},
	},

	-- Parinfer (alternative to vim-sexp if you prefer)
	{
		"gpanders/nvim-parinfer",
		ft = { "clojure", "scheme", "lisp" },
	},
}
