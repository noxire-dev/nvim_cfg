return {
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = {
        python = { 'ruff' },
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
      }

      local group = vim.api.nvim_create_augroup('user-lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
        group = group,
        callback = function(args)
          local linters = lint.linters_by_ft[vim.bo[args.buf].filetype]
          if not linters then return end
          for _, linter_name in ipairs(linters) do
            if linter_name == 'eslint_d' and vim.fn.executable 'eslint_d' == 0 then
              return
            end
          end
          lint.try_lint()
        end,
      })
    end,
  },
}
