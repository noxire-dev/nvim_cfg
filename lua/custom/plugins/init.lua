-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { -- Modern, minimal UI utilities
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      notifier = { enabled = true, style = 'compact' },
      dashboard = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      quickfile = { enabled = true },
      statuscolumn = { enabled = true },
      words = { enabled = true },
      scope = { enabled = true },
    },
    keys = {
      { '<leader>n', function() Snacks.notifier.show_history() end, desc = '[N]otification history' },
      { '<leader>bd', function() Snacks.bufdelete() end, desc = '[B]uffer [D]elete' },
      { '<leader>gg', function() Snacks.lazygit() end, desc = 'Lazy[G]it' },
      { '<leader>gb', function() Snacks.git.blame_line() end, desc = '[G]it [B]lame Line' },
      { ']]', function() Snacks.words.jump(vim.v.count1) end, desc = 'Next reference', mode = { 'n', 't' } },
      { '[[', function() Snacks.words.jump(-vim.v.count1) end, desc = 'Prev reference', mode = { 'n', 't' } },
    },
  },

  { -- Flash for fast navigation
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('flash').jump() end, desc = 'Flash' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('flash').treesitter() end, desc = 'Flash Treesitter' },
      { 'r', mode = 'o', function() require('flash').remote() end, desc = 'Remote Flash' },
      { 'R', mode = { 'o', 'x' }, function() require('flash').treesitter_search() end, desc = 'Treesitter Search' },
      { '<c-s>', mode = { 'c' }, function() require('flash').toggle() end, desc = 'Toggle Flash Search' },
    },
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

  { -- Visual undo history
    'mbbill/undotree',
    keys = {
      { '<leader>u', '<cmd>UndotreeToggle<CR>', desc = '[U]ndo tree' },
    },
  },

  { -- Pretty diagnostics list
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>',                desc = 'Diagnostics (Trouble)' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',   desc = 'Buffer Diagnostics' },
      { '<leader>xs', '<cmd>Trouble symbols toggle<CR>',                    desc = 'Symbols (Trouble)' },
    },
    opts = {},
  },

  { -- Quick file bookmarks
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      vim.keymap.set('n', '<leader>a', function() harpoon:list():add() end, { desc = 'Harpoon [A]dd' })
      vim.keymap.set('n', '<C-e>', function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = 'Harpoon menu' })
      vim.keymap.set('n', '<leader>1', function() harpoon:list():select(1) end, { desc = 'Harpoon 1' })
      vim.keymap.set('n', '<leader>2', function() harpoon:list():select(2) end, { desc = 'Harpoon 2' })
      vim.keymap.set('n', '<leader>3', function() harpoon:list():select(3) end, { desc = 'Harpoon 3' })
      vim.keymap.set('n', '<leader>4', function() harpoon:list():select(4) end, { desc = 'Harpoon 4' })
    end,
  },

  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()

      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
        require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
      return {
        -- lsp_keymaps = false,
        -- other options
      }
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  }
}
