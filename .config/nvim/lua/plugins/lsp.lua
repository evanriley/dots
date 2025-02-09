-- plugins/lsp.lua
return {
	-- LSP Support
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"folke/neodev.nvim",
		},
		config = function()
			local lspconfig = require("lspconfig")

			-- Setup mason-lspconfig
			require("mason").setup()
			require("mason-lspconfig").setup({
				-- List of servers to automatically install
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"ts_ls",
					"pyright",
				},
				-- Auto-install configured servers (with lspconfig)
				automatic_installation = true,
			})

			-- Default handlers for all servers
			local default_handlers = {
				autostart = true,
				capabilities = {}, -- blink.cmp handles this
			}

			-- Automatically setup all servers with default config
			require("mason-lspconfig").setup_handlers({
				-- Default handler
				function(server_name)
					lspconfig[server_name].setup(default_handlers)
				end,

				-- Override handler for specific servers if needed
				["lua_ls"] = function()
					lspconfig.lua_ls.setup(vim.tbl_extend("force", default_handlers, {
						settings = {
							Lua = {
								diagnostics = {
									globals = { "vim" },
								},
							},
						},
					}))
				end,
			})
		end,
	},
	-- Autocompletion
	{
		"Saghen/blink.cmp",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"L3MON4D3/LuaSnip",
			"Saghen/blink.compat", -- For nvim-cmp source compatibility
		},
		opts = {
			-- Snippet support
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			-- Sources configuration
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "buffer" },
				{ name = "path" },
				{ name = "nvim_lua" },
			},

			-- Mapping configuration
			mapping = {
				-- Basic mappings
				["<C-n>"] = "next_item",
				["<C-p>"] = "prev_item",
				["<C-b>"] = "scroll_docs_up",
				["<C-f>"] = "scroll_docs_down",
				["<C-Space>"] = "complete",
				["<C-e>"] = "abort",
				["<CR>"] = "confirm",

				-- Tab mapping with snippet support
				["<Tab>"] = function(fallback)
					if blink.visible() then
						blink.select_next()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end,
				["<S-Tab>"] = function(fallback)
					if blink.visible() then
						blink.select_prev()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end,
			},

			-- Formatting
			formatting = {
				format = function(entry, item)
					-- Add icons
					local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_kind())
					if icon then
						item.kind = icon .. " " .. item.kind
					end

					-- Add source
					item.menu = ({
						buffer = "[Buffer]",
						nvim_lsp = "[LSP]",
						luasnip = "[Snippet]",
						path = "[Path]",
						nvim_lua = "[Lua]",
					})[entry.source.name]

					return item
				end,
			},

			-- Experimental features
			experimental = {
				ghost_text = true,
			},

			-- Window appearance
			window = {
				completion = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				},
				documentation = {
					border = "rounded",
					winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
				},
			},

			-- LSP configuration
			lsp = {
				enabled = true,
				-- Signature help (experimental)
				signature_help = {
					enabled = true,
					auto_trigger = true,
				},
			},
		},
		-- Additional configuration for command line completion
		config = function(_, opts)
			local blink = require("blink")
			blink.setup(opts)

			-- Command line completion setup
			blink.setup.cmdline("/", {
				sources = { { name = "buffer" } },
			})

			blink.setup.cmdline(":", {
				sources = {
					{ name = "path" },
					{ name = "cmdline" },
				},
			})
		end,
	},
	-- Snippets
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"rafamadriz/friendly-snippets",
			config = function()
				require("luasnip.loaders.from_vscode").lazy_load()
			end,
		},
		opts = {
			history = true,
			delete_check_events = "TextChanged",
		},
	},

	-- Additional LSP Features
	{
		"nvimdev/lspsaga.nvim",
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				lightbulb = {
					enable = false,
				},
				symbol_in_winbar = {
					enable = false,
				},
			})
		end,
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons",
		},
	},
}
