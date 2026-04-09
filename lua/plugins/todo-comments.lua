return {
  'folke/todo-comments.nvim',
  event = 'BufEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    highlight = {
      pattern = [[.*<(KEYWORDS)\s*]],
    },
  },
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      mode = 'n',
      desc = 'Next [T]odo comment',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      mode = 'n',
      desc = 'Previous [T]odo comment',
    },
    {
      '<leader>st',
      '<CMD>TodoTelescope<CR>',
      mode = 'n',
      desc = '[S]earch [T]odo comments',
    },
  },
}
