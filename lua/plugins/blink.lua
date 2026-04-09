return {
  'saghen/blink.cmp',
  -- optional: provides snippets for the snippet source
  dependencies = { 'L3MON4D3/LuaSnip', version = 'v2.*' },

  version = '1.*',
  event = 'InsertEnter',
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    keymap = { preset = 'enter' },
    snippets = { preset = 'luasnip' },
    appearance = {
      nerd_font_variant = 'mono',
    },
    -- (Default) Only show the documentation popup when manually triggered
    completion = { documentation = { auto_show = true } },
    sources = {
      default = { 'lsp', 'path', 'snippets', 'buffer' },
    },
    fuzzy = { implementation = 'prefer_rust_with_warning' },
    signature = { enabled = true },
  },
  opts_extend = { 'sources.default' },
}
