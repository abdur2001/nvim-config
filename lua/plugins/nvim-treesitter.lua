---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = '*',
    branch = 'main',
    lazy = false,
    event = 'BufRead',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',

    ---@module "nvim-treesitter.configs"
    opts = {
      ensure_installed = { 'lua' },
      ignore_installed = {},
      sync_install = false,
      auto_install = true,
      modules = {},
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    version = 'v0.10.*',
    opts = {
      max_lines = 7,
      multiline_threshold = 3,
    },
  },
}
