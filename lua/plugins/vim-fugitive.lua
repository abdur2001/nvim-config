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

    -- fugitive attaches extra metadata to difftool entries containing the files for comparison
    local function difftool_context()
      local context = vim.fn.getqflist({ context = 1 }).context
      if type(context) == "table" and context.items then
        return context
      end
    end

    local function open_diff(index)
      local context = difftool_context()
      if not context then
        return
      end
      local diffs = context.items[index].diff

      -- when triggered from a diff window rather than the quickfix window, reuse the first diff window
      local first_winid = difftool_winids[1]
      if
        vim.bo.buftype ~= "quickfix"
        and first_winid
        and vim.api.nvim_win_is_valid(first_winid)
      then
        vim.api.nvim_set_current_win(first_winid)
      end

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
    end

    -- step through the quickfix list (wrapping), opening the diff of each entry; plain
    -- :cnext/:cprevious when the list is not a fugitive difftool
    local function step_diff(direction)
      local step = direction * vim.v.count1
      if not difftool_context() then
        vim.cmd(step > 0 and (step .. "cnext") or (-step .. "cprevious"))
        return
      end
      local qf = vim.fn.getqflist({ idx = 0, size = 0 })
      if qf.size == 0 then
        return
      end
      open_diff((qf.idx - 1 + step) % qf.size + 1)
    end

    vim.keymap.set("n", "]q", function()
      step_diff(1)
    end, { desc = "Next quickfix entry (opens diff for difftool)" })
    vim.keymap.set("n", "[q", function()
      step_diff(-1)
    end, { desc = "Previous quickfix entry (opens diff for difftool)" })

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
          open_diff(vim.fn.line("."))
        end, { buffer = bufnr, desc = "Open selected file diff" })
      end,
    })
  end,
}
