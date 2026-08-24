-- Map icons for opencode to be more visible
local opencode_states = {
  ["󰚩"] = { icon = "●", color = "#a7c080" },
  ["󱜙"] = { icon = "◐", color = "#dbbc7f" },
  ["󱚡"] = { icon = "⊗", color = "#e67e80" },
  ["󱚧"] = { icon = "○", color = "#859289" },
}

local function opencode_state()
  local icon = vim.fn.strcharpart(require("opencode").statusline(), 0, 1)
  return opencode_states[icon] or { icon = icon, color = "#859289" }
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {
    theme = "everforest",
    sections = {
      lualine_a = {
        {
          "filename",
          path = 1,
        },
      },
      lualine_c = {},
      lualine_x = { "fileformat", "filetype" },
      lualine_y = {},
      lualine_z = {
        {
          function()
            return opencode_state().icon
          end,
          color = function()
            return { fg = opencode_state().color, bg = "#2d353b", gui = "bold" }
          end,
        },
      },
    },
  },
}
