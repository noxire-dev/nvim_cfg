local map = vim.keymap.set

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = '[C]ode [D]iagnostic float' })
map('n', '<leader>td', function()
  local enabled = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not enabled)
  vim.notify('Diagnostics ' .. (enabled and 'disabled' or 'enabled'))
end, { desc = '[T]oggle [D]iagnostics' })

map('n', '<leader>tl', function()
  vim.o.list = not vim.o.list
end, { desc = '[T]oggle [L]ist chars' })

map('n', '<leader>tw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = '[T]oggle [W]rap' })

map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

map('n', '<C-s>', '<cmd>w<CR>', { desc = 'Save file' })
map('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file' })

map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

map('n', '<', '<<', { desc = 'Outdent' })
map('n', '>', '>>', { desc = 'Indent' })
map('v', '<', '<gv', { desc = 'Outdent and reselect' })
map('v', '>', '>gv', { desc = 'Indent and reselect' })

map('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down centered' })
map('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up centered' })

map('n', 'n', 'nzzzv', { desc = 'Next search result centered' })
map('n', 'N', 'Nzzzv', { desc = 'Prev search result centered' })

map('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

map('x', '<leader>p', '"_dP', { desc = 'Paste without yanking' })
map({ 'n', 'v' }, '<leader>y', '"+y', { desc = '[Y]ank to system clipboard' })
map('n', '<leader>Y', '"+Y', { desc = '[Y]ank line to system clipboard' })
map({ 'n', 'v' }, '<leader>d', '"_d', { desc = '[D]elete without yank' })

map('n', '<leader>cR', '<cmd>LspRestart<CR>', { desc = '[C]ode LSP [R]estart' })
