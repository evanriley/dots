return {
  {
    'thesimonho/kanagawa-paper.nvim',
    priority = 1000, -- Make sure to load this before all the other start plugins.
    lazy = false,
    config = function()
      require('kanagawa-paper').setup {
        undercurl = true,
        commentStyle = { italic = false },
        keywordStyle = { italic = false },
        integrations = {
          wezterm = {
            enabled = true,
            path = (os.getenv 'TEMP' or '/tmp') .. '/nvim-theme',
          },
        },
      }
    end,
    init = function()
      vim.cmd.colorscheme 'kanagawa-paper-ink'
    end,
  },
}
