return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.basics').setup {
        options = {
          basic = true,
          extra_ui = true,
          win_borders = 'bold',
        },
        mappings = {
          basic = true,
          windows = true,
        },
        autocommands = {
          basic = true,
          relnum_in_visual_mode = true,
        },
      }
      require('mini.pairs').setup()
      require('mini.bracketed').setup()
      require('mini.jump').setup()
      require('mini.ai').setup { n_lines = 500 }
      require('mini.trailspace').setup()
      require('mini.surround').setup()
      require('mini.icons').setup()
      require('mini.move').setup {
        mappings = {
          left = '<M-S-h>',
          right = '<M-S-l>',
          down = '<M-S-j>',
          up = '<M-S-k>',
          line_left = '<M-S-h>',
          line_right = '<M-S-l>',
          line_down = '<M-S-j>',
          line_up = '<M-S-k>',
        },
      }
      local statusline = require 'mini.statusline'
      statusline.setup {}
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end
    end,
  },
}
