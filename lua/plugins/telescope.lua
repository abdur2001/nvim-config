---@module "lazy"
---@type LazyPluginSpec[]
return {
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'nvim-telescope/telescope-ui-select.nvim',
      {
        'nvim-telescope/telescope-live-grep-args.nvim',
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = '^1.0.0',
      },
    },
    cmd = 'Telescope',
    opts = function(_, opts)
      opts.defaults = {
        mappings = {
          i = {
            ['<C-y>'] = function(_)
              local entry = require('telescope.actions.state').get_selected_entry()
              local result = entry[1]
              -- Note: using input here to force notification.
              vim.fn.input("Yanked: '" .. result .. "'\nPress Enter to continue...")
              vim.fn.setreg('"0', result)
            end,
          },
        },
      }
      opts.pickers = {
        colorscheme = {
          enable_preview = true,
          ignore_builtins = false,
          theme = 'dropdown',
          -- layout_config = {
          --   prompt_position = 'top',
          -- },
        },
      }
      opts.extensions = {
        live_grep_args = {
          auto_quoting = true,
          mappings = {
            i = {
              ['<C-t>'] = require('telescope-live-grep-args.actions').quote_prompt(),
              ['<C-i>'] = require('telescope-live-grep-args.actions').quote_prompt { postfix = ' --iglob ' },
              -- freeze the current list and start a fuzzy search in the frozen list
              ['<C-space>'] = require('telescope-live-grep-args.actions').to_fuzzy_refine,
            },
          },
        },
      }
    end,
    ---@module "lazy"
    ---@type "LazyKeysSpec"
    keys = {
      {
        '<leader>sh',
        '<cmd>Telescope help_tags<cr>',
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        '<cmd>Telescope keymaps<cr>',
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>f',
        '<cmd>Telescope find_files hidden=true<cr>',
        desc = 'Search [F]iles',
      },
      {
        '<leader>ss',
        '<cmd>Telescope builtin<cr>',
        desc = '[S]earch [S]elect Telescope',
      },
      {
        '<leader>sw',
        '<cmd>Telescope grep_string<cr>',
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sd',
        '<cmd>Telescope diagnostics<cr>',
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sr',
        '<cmd>Telescope resume<cr>',
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        '<cmd>Telescope oldfiles<cr>',
        desc = '[S]earch Recent Files ("." for repeat)',
      },
      {
        '<leader><leader>',
        '<cmd>Telescope buffers<cr>',
        desc = '[ ] Find Existing Buffers',
      },
      {
        '<leader>sn',
        function()
          require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]vim Files',
      },
      {
        '<leader>sg',
        function()
          require('telescope').extensions.live_grep_args.live_grep_args()
        end,
        desc = '[S]earch [S]elect Telescope',
      },
      -- vim.keymap.set('n', '<leader>sg', ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = '[S]earch by [G]rep' })
    },
  },
}
