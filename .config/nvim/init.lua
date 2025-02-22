-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath('data') .. '/site/'
local mini_path = path_package .. 'pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require('mini.deps').setup({ path = { package = path_package } })

local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later


-- Vim Options
now(function()
  vim.g.mapleader = " "
  vim.g.maplocalleader = ","
  vim.opt.number = true
  vim.opt.relativenumber = true
  vim.opt.signcolumn = 'number'
  vim.opt.laststatus = 2
  vim.opt.mouse = 'a'
  vim.opt.showmode = false
  vim.opt.clipboard = 'unnamed,unnamedplus'
  vim.opt.updatetime = 250
  vim.opt.timeoutlen = 300
  vim.opt.scrolloff = 10
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.softtabstop = 2
  vim.opt.wrap = false -- Display long lines as-is
  vim.opt.list = false
  vim.opt.cmdheight = 0
end)

-- Plugins (mostly from mini.nvim)

-- Colorscheme
add({ source = 'RRethy/base16-nvim' })
now(function()
  vim.api.nvim_set_option_value('background', 'dark', {})
  vim.cmd('colorscheme base16-nord')
end)

add({
  source = 'nvim-treesitter/nvim-treesitter',
  depends = { 'PaterJason/nvim-treesitter-sexp', },
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})
now(function()
  require('nvim-treesitter.configs').setup({
    ensure_installed = {
      'bash',
      'c',
      'clojure',
      'eex',
      'elixir',
      'go',
      'gomod',
      'gosum',
      'gowork',
      'heex',
      'html',
      'lua',
      'luadoc',
      'markdown',
      'ron',
      'rust',
      'toml',
      'vim',
      'vimdoc',
    },
    highlight = { enable = true, },
    indent = { enable = true, },
    incremental_selection = { enable = true, },
  })
end)

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
end)

later(function()
  require("mini.bracketed").setup()
end)

later(function()
  require("mini.bufremove").setup()
end)

later(function()
  require("mini.comment").setup()
end)


add({
  -- Mason and LSP configs
  source = 'williamboman/mason.nvim',
  depends = { 'williamboman/mason-lspconfig.nvim', 'neovim/nvim-lspconfig' }
})


now(function()
  require('mason').setup()
end)

now(function()
  require('mason-lspconfig').setup({
    ensure_installed = {
      'clojure_lsp',
      'elixirls',
      'gopls',
      'jdtls',
      'lua_ls',
      'rust_analyzer',
      'ts_ls',
      'zls'
    },
    automatic_installation = true,
  })
end)

now(function()
  require('mason-lspconfig').setup_handlers({
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,
  })
end)

now(function()
  require('lspconfig').gleam.setup({})
end)

now(function()
  require("mini.completion").setup({
    mappings = {
      go_in = "<RET>",
    },
    window = {
      info = { border = "solid" },
      signature = { border = "solid" },
    },
  })
end)

later(function()
  require("mini.cursorword").setup()
end)

later(function()
  require("mini.diff").setup({
    view = {
      style = "sign",
      signs = { add = "█", change = "▒", delete = "" },
    },
  })
end)

later(function()
  require("mini.extra").setup()
end)

add({ source = "stevearc/oil.nvim" })
now(function()
  require('oil').setup({
    default_file_explorer = true,
    columns = {
      "size",
    },
    delete_to_trash = true,
    skip_confirm_for_simple_edits = true,
  })
end)

add({ source = "stevearc/conform.nvim" })
now(function()
  require("conform").setup({
    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
    formatters_by_ft = {
      lua = { "stylua" },
      go = { "gofmt", "goimports", },
    },
  })
end)

later(function()
  require("mini.fuzzy").setup()
end)

later(function()
  require("mini.git").setup()
end)


later(function()
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
      -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
      fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
      hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
      todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
      note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

      -- Cloaking Passwords
      pw = password_table,

      -- Highlight hex color strings (`#rrggbb`) using that color
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

later(function()
  require("mini.icons").setup()
end)

later(function()
  require("mini.jump").setup()
end)

later(function()
  require("mini.jump2d").setup()
end)

later(function()
  require("mini.misc").setup()
end)

later(function()
  require("mini.move").setup({
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = '<M-S-h>',
      right = '<M-S-l>',
      down = '<M-S-j>',
      up = '<M-S-k>',

      -- Move current line in Normal mode
      line_left = '<M-S-h>',
      line_right = '<M-S-l>',
      line_down = '<M-S-j>',
      line_up = '<M-S-k>',
    },
  }
  )
end)


later(function()
  --          ┌─────────────────────────────────────────────────────────┐
  --            We took this from echasnovski's personal configuration
  --           https://github.com/echasnovski/nvim/blob/master/init.lua
  --          └─────────────────────────────────────────────────────────┘
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


later(function()
  local H = {}

  H.keys = {
    ['cr'] = vim.api.nvim_replace_termcodes('<CR>', true, true, true),
    ['ctrl-y'] = vim.api.nvim_replace_termcodes('<C-y>', true, true, true),
    ['ctrl-y_cr'] = vim.api.nvim_replace_termcodes('<C-y><CR>', true, true, true),
  }

  cr_action = function()
    if vim.fn.pumvisible() ~= 0 then
      local item_selected = vim.fn.complete_info()['selected'] ~= -1
      return item_selected and H.keys['ctrl-y'] or H.keys['ctrl-y_cr']
    else
      return require('mini.pairs').cr()
    end
  end
  require("mini.pairs").setup({ modes = { insert = true, command = true, terminal = true } })
  vim.keymap.set('i', '<CR>', 'v:lua.cr_action()', { expr = true })
end)


later(function()
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
    mappings = {
      choose_in_vsplit = "<C-CR>",
    },
    options = {
      use_cache = true,
    },
    window = {
      config = win_config,
    },
  })
  vim.ui.select = MiniPick.ui_select
end)

now(function()
  require("mini.sessions").setup({
    autowrite = true,
  })
end)

add({ source = "rafamadriz/friendly-snippets" })
later(function()
  local gen_loader = require('mini.snippets').gen_loader
  require("mini.snippets").setup({
    snippets = {
      gen_loader.from_lang()
    }
  })
end)

later(function()
  require("mini.splitjoin").setup()
end)

later(function()
  require("mini.statusline").setup()
end)

later(function()
  require("mini.surround").setup()
end)

later(function()
  require("mini.trailspace").setup()
end)

later(function()
  require("mini.visits").setup()
end)

-- Testing
add({
  source = 'nvim-neotest/neotest',
  depends = {
    'nvim-neotest/nvim-nio',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-lua/plenary.nvim',
    'jfpedroza/neotest-elixir',
    'lawrence-laz/neotest-zig'
  }
})

later(function()
  require('neotest').setup({
    adapters = {
      require("neotest-elixir"),
      require("neotest-zig") {
        dap = { adapter = "lldb", }
      }
    }
  })
end)

-- Debuggers
add({
  source = 'mfussenegger/nvim-dap',
  depends = { 'rcarriga/nvim-dap-ui', 'nvim-neotest/nvim-nio', 'williamboman/mason.nvim', 'jay-babu/mason-nvim-dap.nvim', 'leoluz/nvim-dap-go' },
})
later(function()
  local dap = require 'dap'
  local dapui = require 'dapui'
  require('mason-nvim-dap').setup {
    automatic_setup = true,
    handlers = {},
    ensure_installed = {
      'delve',
      'java-debug-adapter',
      'clojure-dap'
    },
  }
  vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug: Start/Continue' })
  vim.keymap.set('n', '<F1>', dap.step_into, { desc = 'Debug: Step Into' })
  vim.keymap.set('n', '<F2>', dap.step_over, { desc = 'Debug: Step Over' })
  vim.keymap.set('n', '<F3>', dap.step_out, { desc = 'Debug: Step Out' })
  vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  vim.keymap.set('n', '<leader>B', function()
    dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  end, { desc = 'Debug: Set Breakpoint' })
  -- Dap UI setup
  dapui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
  vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })

  dap.listeners.after.event_initialized['dapui_config'] = dapui.open
  dap.listeners.before.event_terminated['dapui_config'] = dapui.close
  dap.listeners.before.event_exited['dapui_config'] = dapui.close

  require('dap-go').setup()
end)

-- Language requirements
-- General
--- Neorg
add({
  source = "nvim-neorg/neorg",
  depends = { 'nvim-neorg/lua-utils.nvim', 'pysan3/pathlib.nvim' },
})
now(function()
  require("neorg").setup({
    load = {
      ["core.defaults"] = {},
      ["core.concealer"] = {},
      ["core.dirman"] = {
        config = {
          workspaces = {
            notes = "~/sync/neorg"
          },
          default_workspace = "notes",
        }
      },
    }
  })
  vim.wo.foldlevel = 99
  vim.wo.conceallevel = 2
end)
--- Clojure
add({
  source = 'gpanders/nvim-parinfer'
})

add({
  source = 'Olical/conjure',
})
now(function()
  vim.g.parinfer_mode = "indent"      -- Force indent mode
  vim.g.parinfer_enabled = 1          -- Enable parinfer
  vim.g.parinfer_force_balance = true -- Force balanced parentheses
end)

require('autocmds')
require('keymaps')
