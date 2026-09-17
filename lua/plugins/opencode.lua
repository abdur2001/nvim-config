return {
  "nickjvandyke/opencode.nvim",
  version = "v1.*", -- Latest stable release
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      server = {
        start = function()
          require("snacks.terminal").open({ vim.fn.expand("~/.codemate/run_opencode.sh"), "--port" }, {
            win = {
              position = "right",
              enter = false,
            },
          })
        end,
      },
    }

    vim.keymap.set({ "n", "x" }, "<leader>oa", function()
      require("opencode").ask("@this: ")
    end, { desc = "Ask OpenCode…" })
    vim.keymap.set({ "n", "x" }, "<leader>os", function()
      require("opencode").select()
    end, { desc = "Select OpenCode…" })
    vim.keymap.set({ "n", "x" }, "go", function()
      return require("opencode").operator("@this ")
    end, { desc = "Append range to OpenCode", expr = true })

    vim.keymap.set({ "n" }, "goo", function()
      return require("opencode").operator("@this ") .. "_"
    end, { desc = "Append line to OpenCode", expr = true })
  end,
}
