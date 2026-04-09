return {
  'stevearc/conform.nvim',
  version = '*',
  event = 'BufWritePre',
  command = 'ConformInfo',
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[L]SP [F]ormat buffer',
    },
  },
  ---@module "conform"
  ---@type conform.setupOpts
  opts = {

    formatters_by_ft = {
      lua = { 'stylua' },
      python = { 'ruff_format', 'ruff_organize_imports' },
      markdown = { 'injected' },
      ['*'] = { 'trim_whitespace' },
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
    format_on_save = { timeout_ms = 500 },
  },
}
