local api = vim.api

api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = api.nvim_create_augroup('user-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

api.nvim_create_autocmd('BufReadPost', {
  desc = 'Restore last cursor position',
  group = api.nvim_create_augroup('user-last-position', { clear = true }),
  callback = function(args)
    local mark = api.nvim_buf_get_mark(args.buf, '"')
    local line_count = api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

api.nvim_create_autocmd({ 'FocusLost', 'BufLeave' }, {
  desc = 'Auto-save on focus loss',
  group = api.nvim_create_augroup('user-autosave', { clear = true }),
  callback = function(args)
    if vim.bo[args.buf].modifiable and vim.bo[args.buf].buftype == '' and vim.api.nvim_buf_get_name(args.buf) ~= '' then
      pcall(vim.cmd.update)
    end
  end,
})

api.nvim_create_autocmd('FileType', {
  desc = 'Close certain filetypes with q',
  group = api.nvim_create_augroup('user-quick-close', { clear = true }),
  pattern = { 'help', 'qf', 'lspinfo', 'man', 'checkhealth', 'fugitive', 'startuptime' },
  callback = function(args)
    vim.bo[args.buf].buflisted = false
    vim.keymap.set('n', 'q', '<cmd>close<CR>', { buffer = args.buf, silent = true })
  end,
})
