return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    config = function()
      require('lualine').setup {
        options = {
          theme = function()
            -- pcall and fallback theme is to handle the case of theme switching/previewing
            local ok, t = pcall(require, 'lualine.themes.' .. (vim.o.background == 'light' and 'kanagawa-paper-canvas' or 'kanagawa-paper-ink'))
            if ok then
              theme = t
            else
              theme = 'auto'
            end
            return theme
          end,
          icons_enabled = true,
          section_separators = { left = '', right = '' },
          component_separators = { left = '', right = '' },
          disabled_filetypes = { 'NvimTree', 'dashboard', 'alpha' },
        },
        sections = {
          lualine_a = { { 'mode', icon = '' } },
          lualine_b = { { 'branch', icon = '' }, 'diff', 'diagnostics' },
          lualine_c = { { 'filename', path = 1 } },
          lualine_x = { 'encoding', 'fileformat', 'filetype' },
          lualine_y = { 'progress' },
          lualine_z = { { 'location', icon = '' } },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'filename' },
          lualine_x = { 'location' },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = { 'nvim-tree', 'quickfix' },
      }
    end,
  },
}
