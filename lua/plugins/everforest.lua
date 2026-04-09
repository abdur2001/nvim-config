---@module "lazy"
---@type LazyPluginSpec
return {
  'neanias/everforest-nvim',
  version = false,
  lazy = false,
  priority = 1000,
  ---@module "everforest"
  ---@type Everforest.Config
  opts = {
    background = 'hard',
    float_style = 'blend',
    on_highlights = function(hl, palette)
      hl.CurrentWord = { bg = '#4d2e3e', bold = true }
    end,
  },
  main = 'everforest',
}
