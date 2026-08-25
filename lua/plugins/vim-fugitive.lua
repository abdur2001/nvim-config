return {
  "tpope/vim-fugitive",
  cmd = {
    "Git",
    "G",
    "Gdiffsplit",
    "Gvdiffsplit",
    "Gread",
    "Gwrite",
    "Ggrep",
    "GMove",
    "GRename",
    "GDelete",
    "GBrowse",
  },
  event = "BufReadPost",
  config = function()
    local difftool_winids = {}

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "fugitive",
      callback = function()
        vim.api.nvim_win_set_height(0, math.max(1, math.floor(vim.o.lines * 0.20)))
      end,
    })

    vim.api.nvim_create_autocmd("QuickFixCmdPost", {
      -- custom event emitted by Fugitive
      pattern = "cfugitive-difftool",
      callback = function()
        -- get the qfix windid
        local winid = vim.fn.getqflist({ winid = 0 }).winid
        if winid == 0 then
          return
        end

        local bufnr = vim.api.nvim_win_get_buf(winid)
        vim.keymap.set("n", "<CR>", function()
          -- fugitive attaches extra metadata to difftool entries containig the file for comparison
          local index = vim.fn.line(".")
          local context = vim.fn.getqflist({ context = 1 }).context
          local diffs = context.items[index].diff

          vim.cmd("cc " .. index)
          -- close windows from other comparisons
          local target_winid = vim.api.nvim_get_current_win()
          for _, winid in ipairs(difftool_winids) do
            if winid ~= target_winid and vim.api.nvim_win_is_valid(winid) then
              vim.api.nvim_win_close(winid, false)
            end
          end

          -- remove existing diffd
          vim.cmd("diffoff!")
          local existing_winids = {}
          for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            existing_winids[winid] = true
          end

          -- open possible multiple diffs for entry
          for _, diff in ipairs(diffs) do
            vim.cmd("vertical Gdiffsplit! " .. vim.fn.fnameescape(diff.filename))
          end

          difftool_winids = { target_winid }
          for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if not existing_winids[winid] then
              table.insert(difftool_winids, winid)
            end
          end
        end, { buffer = bufnr, desc = "Open selected file diff" })
      end,
    })
  end,
}
