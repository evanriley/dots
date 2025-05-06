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
  },
  {
    'RRethy/base16-nvim',
    opt = {},
  },
  {
    'f-person/auto-dark-mode.nvim',
    lazy = false,
    config = function()
      require('auto-dark-mode').setup {
        update_interval = 1000,
        set_dark_mode = function()
          vim.cmd 'colorscheme kanagawa-paper-ink'
        end,
        set_light_mode = function()
          require('base16-colorscheme').setup {
            base00 = '#FCFBF9', -- Default Background
            base01 = '#F7F3EE', -- Lighter Background (status bars)
            base02 = '#E4DAE0', -- Selection Background
            base03 = '#BEBBB6', -- Comments, Invisibles, Line Highlighting
            base04 = '#E5DED5', -- Dark Foreground (status bars)
            base05 = '#605A52', -- Default Foreground, Caret, Delimiters, Operators
            base06 = '#7F7A73', -- Light Foreground (not often used)
            base07 = '#FCFBF9', -- Light Background (not often used)
            base08 = '#8F5652', -- Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
            base09 = '#886A44', -- Integers, Boolean, Constants, XML Attributes, Markup Link Url
            base0A = '#E6DAD8', -- Classes, Markup Bold, Search Text Background
            base0B = '#747B4D', -- Strings, Inherited Class, Markup Code, Diff Inserted
            base0C = '#477A7B', -- Support, Regular Expressions, Escape Characters, Markup Quotes
            base0D = '#556995', -- Functions, Methods, Attribute IDs, Headings
            base0E = '#83577D', -- Keywords, Storage, Selector, Markup Italic, Diff Changed
            base0F = '#D8E1E0', -- Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
          }
        end,
      }
    end,
  },
}
