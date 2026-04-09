local find_entry_points_settings = {
  use_importlib = false,
  python_path = '/opt/third/python/3.12/root/bin/python3.12',
}
return {
  'CaetanoGenete/python-tools.nvim',
  tag = 'v0.3.1',
  keys = {
    {
      '<leader>le',
      function()
        require('python_tools.pickers').find_entry_points(vim.tbl_extend('force', find_entry_points_settings, { group = 'spde.apps' }))
      end,
      desc = 'Find spde apps',
    },
    {
      '<leader>lE',
      function()
        require('python_tools.pickers').find_entry_points(find_entry_points_settings)
      end,
      desc = 'Find python entry-points',
    },
  },
  submodules = false,
}
