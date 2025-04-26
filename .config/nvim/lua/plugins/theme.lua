return {
  -- {
  --   'rebelot/kanagawa.nvim',
  --   priority = 1000, -- Make sure to load this before all the other start plugins.
  --   config = function()
  --     require('kanagawa').setup {
  --       undercurl = false,
  --       commentStyle = { italic = false },
  --       keywordStyle = { italic = false },
  --       background = {
  --         dark = 'dragon',
  --         light = 'lotus',
  --       },
  --     }
  --   end,
  --   init = function()
  --     vim.cmd.colorscheme 'kanagawa'
  --   end,
  -- },
  {
    'metalelf0/black-metal-theme-neovim',
    lazy = false,
    priority = 1000,
    config = function()
      require('black-metal').setup {
        theme = 'taake',
        coding_style = {
          comments = 'none',
        },
      }
      require('black-metal').load()
    end,
  },
}
