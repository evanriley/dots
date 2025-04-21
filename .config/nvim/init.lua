-- Bootstrap mini.nvim for plugin management
local function bootstrap_mini()
  local path_package = vim.fn.stdpath("data") .. "/site/"
  local mini_path = path_package .. "pack/deps/start/mini.nvim"

  if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/echasnovski/mini.nvim",
      mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
  end

  return path_package
end

-- Initialize mini.deps
local path_package = bootstrap_mini()
require("mini.deps").setup({ path = { package = path_package } })
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- =============================================================================
-- BASIC SETTINGS
-- =============================================================================
now(function()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","

  -- UI settings
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = "number"
  vim.opt.laststatus = 2
  vim.opt.mouse = "a"
  vim.opt.showmode = false
  vim.opt.scrolloff = 10
  vim.opt.cmdheight = 0

  -- Editing settings
  vim.opt.clipboard = "unnamedplus"
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.wrap = false
  vim.opt.list = false

  -- Search settings
  vim.opt.ignorecase = true
  vim.opt.smartcase = true
  vim.opt.incsearch = true
  vim.opt.hlsearch = true

  -- Undo
  vim.opt.undofile = true
  vim.opt.undodir = vim.fn.stdpath("data") .. "/undodir"

  -- Code folding
  vim.opt.foldmethod = "expr"
  vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
  vim.opt.foldenable = false
  vim.opt.foldlevel = 99
end)

-- =============================================================================
-- COLORSCHEME
-- =============================================================================
add({ source = "rebelot/kanagawa.nvim" })
now(function()
  vim.api.nvim_set_option_value("background", "dark", {})
  vim.cmd("colorscheme kanagawa-dragon")
end)

-- =============================================================================
-- CORE FUNCTIONALITY
-- =============================================================================

-- Treesitter for syntax highlighting and code parsing
add({
  source = "nvim-treesitter/nvim-treesitter",
  depends = { "PaterJason/nvim-treesitter-sexp" },
  hooks = {
    post_checkout = function()
      vim.cmd("TSUpdate")
    end,
  },
})
now(function()
  require("nvim-treesitter.configs").setup({
    ensure_installed = {
      "bash",
      "c",
      "clojure",
      "eex",
      "elixir",
      "go",
      "gomod",
      "gosum",
      "gowork",
      "gleam",
      "heex",
      "html",
      "lua",
      "luadoc",
      "markdown",
      "ron",
      "rust",
      "toml",
      "vim",
      "vimdoc",
    },
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = { enable = true },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
        },
      },
    },
  })
end)

-- File explorer
add({ source = "stevearc/oil.nvim" })
now(function()
  require("oil").setup({
    default_file_explorer = true,
    columns = { "size" },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  })
end)

-- Code formatting
add({ source = "stevearc/conform.nvim" })
now(function()
  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports" },
      gleam = { "gleam" },
      zigfmt = { "zigfmt" },
    },
  })
end)

-- Sessions
now(function()
  require("mini.sessions").setup({
    autowrite = true,
  })
end)

-- Terminal
add({ source = "akinsho/toggleterm.nvim" })
later(function()
  require("toggleterm").setup({
    open_mapping = [[<c-\>]],
    direction = "float",
    float_opts = {
      border = "curved",
    },
  })
end)

-- window movement
add({ source = "mrjones2014/smart-splits.nvim" })
now(function()
  require('smart-splits').setup({})
end)

-- =============================================================================
-- LSP CONFIGURATION
-- =============================================================================
add({
  source = "williamboman/mason.nvim",
  depends = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
})

now(function()
  -- Mason setup
  require("mason").setup()

  -- Mason-lspconfig setup
  require("mason-lspconfig").setup({
    ensure_installed = {
      "clojure_lsp",
      "lua_ls",
      "rust_analyzer",
      "zls",
    },
    automatic_installation = true,
  })

  -- LSP server setup
  require("mason-lspconfig").setup_handlers({
    function(server_name)
      require("lspconfig")[server_name].setup({})
    end,
  })

  -- Manual LSP setup
  require("lspconfig").gleam.setup({})

  -- Completion
  require("mini.completion").setup({
    mappings = { go_in = "<RET>" },
    window = {
      info = { border = "solid" },
      signature = { border = "solid" },
    },
  })
end)

now(function()
  -- Enable inlay hints (for supported LSPs)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
      end
    end,
  })

  -- Global diagnostic settings
  vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      border = "rounded",
      source = "always",
    },
  })
end)

-- =============================================================================
-- MINI.NVIM PLUGINS
-- =============================================================================

-- Basic editing enhancements
later(function()
  require("mini.basics").setup({
    options = {
      basic = true,
      extra_ui = true,
      win_borders = "bold",
    },
    mappings = {
      basic = true,
      windows = true,
    },
    autocommands = {
      basic = true,
      relnum_in_visual_mode = true,
    },
  })

  require("mini.comment").setup()
  require("mini.cursorword").setup()
  require("mini.trailspace").setup()
  require("mini.extra").setup()
  require("mini.misc").setup()
end)

-- Navigation and movement
later(function()
  require("mini.bracketed").setup()
  require("mini.jump").setup()
  require("mini.jump2d").setup()

  require("mini.move").setup({
    mappings = {
      left = "<M-S-h>",
      right = "<M-S-l>",
      down = "<M-S-j>",
      up = "<M-S-k>",
      line_left = "<M-S-h>",
      line_right = "<M-S-l>",
      line_down = "<M-S-j>",
      line_up = "<M-S-k>",
    },
  })
end)

-- Buffer management
later(function()
  require("mini.bufremove").setup()
end)

-- UI enhancements
later(function()
  -- Status line
  require("mini.statusline").setup()

  -- Git integration
  require("mini.git").setup()
  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "█", change = "▒", delete = "" },
    },
  })

  -- Icons
  require("mini.icons").setup()

  -- Fuzzy finding
  require("mini.fuzzy").setup()

  -- Window picker
  local win_config = function()
    local height = math.floor(0.618 * vim.o.lines)
    local width = math.floor(0.4 * vim.o.columns)
    return {
      anchor = "NW",
      height = height,
      width = width,
      border = "solid",
      row = math.floor(0.5 * (vim.o.lines - height)),
      col = math.floor(0.5 * (vim.o.columns - width)),
    }
  end

  require("mini.pick").setup({
    mappings = { choose_in_vsplit = "<C-CR>" },
    options = { use_cache = true },
    window = { config = win_config },
  })
  vim.ui.select = MiniPick.ui_select
end)

-- Notifications
later(function()
  local filterout_lua_diagnosing = function(notif_arr)
    local not_diagnosing = function(notif)
      return not vim.startswith(notif.msg, "lua_ls: Diagnosing")
    end
    notif_arr = vim.tbl_filter(not_diagnosing, notif_arr)
    return MiniNotify.default_sort(notif_arr)
  end

  require("mini.notify").setup({
    content = { sort = filterout_lua_diagnosing },
    window = { config = { border = "solid" } },
  })
  vim.notify = MiniNotify.make_notify()
end)

-- Text manipulation
later(function()
  require("mini.surround").setup()
  require("mini.splitjoin").setup()

  -- Hipatterns for text highlighting
  local hipatterns = require("mini.hipatterns")
  local censor_extmark_opts = function(_, match, _)
    local mask = string.rep("*", vim.fn.strchars(match))
    return {
      virt_text = { { mask, "Comment" } },
      virt_text_pos = "overlay",
      priority = 200,
      right_gravity = false,
    }
  end

  local password_table = {
    pattern = {
      "password: ()%S+()",
      "password_usr: ()%S+()",
      "_pw: ()%S+()",
      "password_asgard_read: ()%S+()",
      "password_elara_admin: ()%S+()",
      "gpg_pass: ()%S+()",
      "passwd: ()%S+()",
      "secret: ()%S+()",
    },
    group = "",
    extmark_opts = censor_extmark_opts,
  }

  hipatterns.setup({
    highlighters = {
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
      pw = password_table,
      hex_color = hipatterns.gen_highlighter.hex_color(),
    },
  })

  vim.keymap.set("n", "<leader>up", function()
    if next(hipatterns.config.highlighters.pw) == nil then
      hipatterns.config.highlighters.pw = password_table
    else
      hipatterns.config.highlighters.pw = {}
    end
    vim.cmd("edit")
  end, { desc = "Toggle Password Cloaking" })
end)

-- Auto pairs
later(function()
  local H = {}
  H.keys = {
    ["cr"] = vim.api.nvim_replace_termcodes("<CR>", true, true, true),
    ["ctrl-y"] = vim.api.nvim_replace_termcodes("<C-y>", true, true, true),
    ["ctrl-y_cr"] = vim.api.nvim_replace_termcodes("<C-y><CR>", true, true, true),
  }

  cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()["selected"] ~= -1
      return item_selected and H.keys["ctrl-y"] or H.keys["ctrl-y_cr"]
    else
      return require("mini.pairs").cr()
    end
  end

  require("mini.pairs").setup({
    modes = { insert = true, command = true, terminal = true },
  })
  vim.keymap.set("i", "<CR>", "v:lua.cr_action()", { expr = true })
end)

-- Snippets
add({ source = "rafamadriz/friendly-snippets" })
later(function()
  local gen_loader = require("mini.snippets").gen_loader
  require("mini.snippets").setup({
    snippets = {
      gen_loader.from_lang(),
    },
  })
end)

-- History tracking
later(function()
  require("mini.visits").setup()
end)

-- =============================================================================
-- TESTING AND DEBUGGING TOOLS
-- =============================================================================

-- Testing framework
add({
  source = "nvim-neotest/neotest",
  depends = {
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-lua/plenary.nvim",
    "jfpedroza/neotest-elixir",
    "lawrence-laz/neotest-zig",
  },
})

later(function()
  require("neotest").setup({
    adapters = {
      require("neotest-elixir"),
      require("neotest-zig")({
        dap = { adapter = "lldb" },
      }),
    },
  })
end)

-- Debugging
add({
  source = "mfussenegger/nvim-dap",
  depends = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
    "leoluz/nvim-dap-go",
  },
})

later(function()
  local dap = require("dap")
  local dapui = require("dapui")

  -- DAP setup
  require("mason-nvim-dap").setup({
    automatic_setup = true,
    handlers = {},
    ensure_installed = {
      "clojure-dap",
    },
  })

  -- DAP keymaps
  vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
  vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
  vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
  vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
  vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
  vim.keymap.set("n", "<leader>B", function()
    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
  end, { desc = "Debug: Set Breakpoint" })

  -- DAP UI setup
  dapui.setup({
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
      icons = {
        pause = "⏸",
        play = "▶",
        step_into = "⏎",
        step_over = "⏭",
        step_out = "⏮",
        step_back = "b",
        run_last = "▶▶",
        terminate = "⏹",
        disconnect = "⏏",
      },
    },
  })

  vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

  dap.listeners.after.event_initialized["dapui_config"] = dapui.open
  dap.listeners.before.event_terminated["dapui_config"] = dapui.close
  dap.listeners.before.event_exited["dapui_config"] = dapui.close

  require("dap-go").setup()
end)

-- =============================================================================
-- LANGUAGE-SPECIFIC CONFIGURATIONS
-- =============================================================================

-- Clojure
add({ source = "gpanders/nvim-parinfer" })
add({ source = "Olical/conjure" })

now(function()
  vim.g.parinfer_mode = "indent"
  vim.g.parinfer_enabled = 1
  vim.g.parinfer_force_balance = true
end)

-- =============================================================================
-- REMOTE DEVELOPMENT TOOLS
-- =============================================================================
add({
  source = "amitds1997/remote-nvim.nvim",
  depends = {
    "nvim-lua/plenary/nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
})

now(function()
  require("remote-nvim").setup()
end)

-- =============================================================================
-- AI ASSISTANCE (testing)
-- =============================================================================

add({
  source = "yetone/avante.nvim",
  monitor = "main",
  depends = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "echasnovski/mini.icons",
  },
  hooks = {
    post_checkout = function()
      vim.cmd("make")
    end,
  },
})
--- optional
add({ source = "zbirenbaum/copilot.lua" })
add({ source = "HakonHarnes/img-clip.nvim" })
add({ source = "MeanderingProgrammer/render-markdown.nvim" })

later(function()
  require("render-markdown").setup()
end)
later(function()
  require("img-clip").setup()
  require("copilot").setup({})
  require("avante").setup({
    provider = "copilot",
    auto_suggestion_provider = "copilot",
    copilot = {
      model = "gpt-4.1",
    },
  })
end)

-- =============================================================================
-- LOAD ADDITIONAL CONFIGURATION FILES
-- =============================================================================
require("autocmds")
require("keymaps")
