return {
  'folke/persistence.nvim',
  event = 'BufReadPre', -- this will only start session saving when an actual file was opened
  opts = {},
  keys = {
    {
      '<leader>ps',
      function()
        require('persistence').load()
      end,
      mode = 'n',
      desc = '[P]ersistence load the [S]ession for the current directory',
    },
    {
      '<leader>pS',
      function()
        require('persistence').select()
      end,
      mode = 'n',
      desc = '[P]ersistence select a [S]ession to load',
    },
    {
      '<leader>pl',
      function()
        require('persistence').load { last = true }
      end,
      mode = 'n',
      desc = '[P]ersistence load the [L]ast session',
    },
    {
      '<leader>pd',
      function()
        require('persistence').stop()
      end,
      mode = 'n',
      desc = '[P]ersistence [D]elete current session so it won save on exit',
    },
  },
}
