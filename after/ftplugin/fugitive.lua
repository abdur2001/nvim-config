vim.api.nvim_create_autocmd("BufWinEnter", {
  buffer = 0,
  once = true,
  callback = function()
    vim.api.nvim_win_set_height(0, 10)
  end,
})
