local severity = vim.diagnostic.severity

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  underline = { severity = severity.ERROR },
  float = { border = 'rounded', source = 'if_many' },
  jump = { float = true },
  virtual_text = {
    spacing = 2,
    prefix = '●',
    source = 'if_many',
  },
  signs = {
    text = {
      [severity.ERROR] = '',
      [severity.WARN] = '',
      [severity.INFO] = '',
      [severity.HINT] = '',
    },
  },
}
