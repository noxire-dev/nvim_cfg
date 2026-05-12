return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'master',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local filetypes = {
        'bash', 'c', 'css', 'diff', 'dockerfile', 'go', 'gomod', 'gosum', 'gowork',
        'gitcommit', 'gitignore', 'html', 'javascript', 'json', 'jsonc',
        'lua', 'luadoc', 'markdown', 'markdown_inline', 'python',
        'query', 'regex', 'sql', 'toml', 'tsx', 'typescript',
        'vim', 'vimdoc', 'yaml',
      }
      require('nvim-treesitter').install(filetypes)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = filetypes,
        callback = function()
          pcall(vim.treesitter.start)
          vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
        end,
      })
    end,
  },
}
