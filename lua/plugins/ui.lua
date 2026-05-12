return {
  {
    'folke/tokyonight.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        style = 'moon',
        transparent = false,
        dim_inactive = true,
        lualine_bold = false,
        styles = {
          comments = { italic = false },
          sidebars = 'transparent',
          floats = 'transparent',
        },
      }
      vim.cmd.colorscheme 'tokyonight-night'
    end,
  },

  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        preset = {
          keys = {
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = ' ', key = 'c', desc = 'Config', action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
            { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
      },
      explorer = { enabled = true },
      indent = { enabled = true, animate = { enabled = false } },
      input = { enabled = true },
      notifier = { enabled = true, style = 'compact' },
      picker = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      terminal = { enabled = true },
      words = { enabled = true },
    },
    keys = {
      { '<leader>n',  function() Snacks.notifier.show_history() end,                       desc = '[N]otification history' },
      { '<leader>bd', function() Snacks.bufdelete() end,                                   desc = '[B]uffer [D]elete' },
      { '<leader>gg', function() Snacks.lazygit() end,                                     desc = 'Lazy[G]it' },
      { '<leader>gb', function() Snacks.git.blame_line() end,                              desc = '[G]it [B]lame Line' },
      { '<leader>gB', function() Snacks.gitbrowse() end,                                   desc = 'Git [B]rowse',                  mode = { 'n', 'v' } },
      { '<leader>e',  function() Snacks.explorer() end,                                    desc = 'File [E]xplorer' },
      { '<C-/>',      function() Snacks.terminal() end,                                    desc = 'Toggle Terminal' },
      { ']]',         function() Snacks.words.jump(vim.v.count1) end,                      desc = 'Next reference',                mode = { 'n', 't' } },
      { '[[',         function() Snacks.words.jump(-vim.v.count1) end,                     desc = 'Prev reference',                mode = { 'n', 't' } },

      { '<leader>sf', function() Snacks.picker.files() end,                                desc = '[S]earch [F]iles' },
      { '<leader>sg', function() Snacks.picker.grep() end,                                 desc = '[S]earch by [G]rep' },
      { '<leader>sw', function() Snacks.picker.grep_word() end,                            desc = '[S]earch [W]ord',               mode = { 'n', 'x' } },
      { '<leader>sh', function() Snacks.picker.help() end,                                 desc = '[S]earch [H]elp' },
      { '<leader>sk', function() Snacks.picker.keymaps() end,                              desc = '[S]earch [K]eymaps' },
      { '<leader>sd', function() Snacks.picker.diagnostics() end,                          desc = '[S]earch [D]iagnostics' },
      { '<leader>sD', function() Snacks.picker.diagnostics_buffer() end,                   desc = '[S]earch buffer [D]iagnostics' },
      { '<leader>sr', function() Snacks.picker.resume() end,                               desc = '[S]earch [R]esume' },
      { '<leader>s.', function() Snacks.picker.recent() end,                               desc = '[S]earch Recent' },
      { '<leader>sc', function() Snacks.picker.commands() end,                             desc = '[S]earch [C]ommands' },
      { '<leader>sn', function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = '[S]earch [N]eovim files' },
      { '<leader>ss', function() Snacks.picker.lsp_symbols() end,                          desc = '[S]earch document [S]ymbols' },
      { '<leader>sS', function() Snacks.picker.lsp_workspace_symbols() end,                desc = '[S]earch workspace [S]ymbols' },
      { '<leader>/',  function() Snacks.picker.lines() end,                                desc = 'Search current buffer' },
      { '<leader><leader>', function() Snacks.picker.buffers() end,                        desc = 'Find buffers' },
    },
    init = function()
      vim.api.nvim_create_autocmd('User', {
        pattern = 'VeryLazy',
        callback = function()
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd
        end,
      })
    end,
  },

  {
    'nvim-mini/mini.nvim',
    event = 'VeryLazy',
    config = function()
      require('mini.icons').setup()
      require('mini.icons').mock_nvim_web_devicons()

      require('mini.ai').setup { n_lines = 500 }
      require('mini.surround').setup()

      local statusline = require 'mini.statusline'
      statusline.setup { use_icons = vim.g.have_nerd_font }
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function() return '%2l:%-2v' end

      require('mini.tabline').setup { show_icons = vim.g.have_nerd_font }
    end,
  },

  {
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = { signs = false },
  },

  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      delay = 0,
      icons = { mappings = vim.g.have_nerd_font },
      show_help = false,
      spec = {
        { '<leader>s', group = '[S]earch',     mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>c', group = '[C]ode' },
        { '<leader>g', group = '[G]it' },
        { '<leader>b', group = '[B]uffer' },
        { '<leader>x', group = 'Trouble/Diagnostics' },
        { '<leader>h', group = 'Git [H]unk',   mode = { 'n', 'v' } },
      },
    },
  },
}
