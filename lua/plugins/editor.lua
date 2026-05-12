return {
  { 'NMAC427/guess-indent.nvim', event = 'BufReadPre', opts = {} },

  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      { 's',     mode = { 'n', 'x', 'o' }, function() require('flash').jump() end,              desc = 'Flash' },
      { 'S',     mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end,        desc = 'Flash Treesitter' },
      { 'r',     mode = 'o',               function() require('flash').remote() end,            desc = 'Remote Flash' },
      { 'R',     mode = { 'o', 'x' },      function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' },           function() require('flash').toggle() end,            desc = 'Toggle Flash Search' },
    },
  },

  {
    'folke/zen-mode.nvim',
    keys = {
      { '<leader>tz', '<cmd>ZenMode<CR>', desc = '[T]oggle [Z]en Mode' },
    },
    opts = {
      window = {
        width = 0.72,
        options = { signcolumn = 'no', number = false, relativenumber = false },
      },
    },
  },

  {
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo tree' },
    },
  },

  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',              desc = 'Diagnostics (Trouble)' },
      { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<CR>',                  desc = 'Symbols (Trouble)' },
      { '<leader>xl', '<cmd>Trouble lsp toggle<CR>',                      desc = 'LSP refs/defs (Trouble)' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<CR>',                   desc = 'Quickfix (Trouble)' },
      { '<leader>xt', '<cmd>Trouble todo toggle<CR>',                     desc = '[T]odo (Trouble)' },
    },
    opts = {},
  },

  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = function()
      local harpoon = require 'harpoon'
      return {
        { '<leader>a', function() harpoon:list():add() end,                                desc = 'Harpoon [A]dd' },
        { '<C-e>',     function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,        desc = 'Harpoon menu' },
        { '<leader>1', function() harpoon:list():select(1) end,                            desc = 'Harpoon 1' },
        { '<leader>2', function() harpoon:list():select(2) end,                            desc = 'Harpoon 2' },
        { '<leader>3', function() harpoon:list():select(3) end,                            desc = 'Harpoon 3' },
        { '<leader>4', function() harpoon:list():select(4) end,                            desc = 'Harpoon 4' },
      }
    end,
    config = function()
      require('harpoon'):setup()
    end,
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    opts = {
      check_ts = true,
      ts_config = {
        lua = { 'string' },
        javascript = { 'template_string' },
      },
    },
  },
}
