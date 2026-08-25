return {
  "folke/which-key.nvim",
  version = "*",
  event = "VeryLazy",
  config = function(_, opts)
    require("which-key").setup(opts)
    require("which-key").add({
      { "zj", desc = "Move to next fold" },
      { "zk", desc = "Move to previous fold" },
      { "<leader>c", name = "[C]ode" },
      { "<leader>d", name = "[D]ocument" },
      { "<leader>s", name = "[S]earch" },
      { "<leader>g", name = "[G]it" },
      { "<leader>h", name = "[H]arpoon" },
      { "<leader>l", name = "[L]SP" },
      { "<leader>o", name = "[O]penCode" },
      { "<leader>p", name = "[P]ersitance" },
      { "<leader>u", name = "[U]I" },
    })
  end,
}
