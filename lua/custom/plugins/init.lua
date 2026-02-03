-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Modern, minimal UI utilities
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {},
  },
  { -- Distraction-free focus mode
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
}
