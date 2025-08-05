return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      servers = {
        ts_ls = {
          filetypes = { 'javascript', 'javascriptreact' },
          single_file_support = true,
          workspace_required = false,
          root_dir = function()
            return vim.fn.getcwd()
          end,
          on_attach = function(_, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
          end,
        },
      },
      setup = {
        ts_ls = function(_, opts)
          require('lspconfig').ts_ls.setup(opts)
          return true
        end,
      },
    },
  },
}
