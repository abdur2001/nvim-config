return {
  'stevearc/oil.nvim',
  ---@module 'oil'
  ---@type oil.SetupOpts
  dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
  -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
  lazy = false,
  opts = {
    default_file_explorer = true, -- handle directory buffers
    columns = {
      'icon',
    },
  },
  keys = { { '-', '<CMD>Oil<CR>', desc = 'Open parent directory' } },
}
