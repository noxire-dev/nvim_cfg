vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

local o = vim.o

o.number = true
o.relativenumber = true
o.numberwidth = 2

o.mouse = 'a'
o.showmode = false
o.termguicolors = true

o.cmdheight = 0
o.laststatus = 3
o.pumblend = 10
o.winblend = 10
o.splitkeep = 'screen'

if vim.fn.has 'nvim-0.10' == 1 then
  o.smoothscroll = true
end

vim.schedule(function()
  o.clipboard = 'unnamedplus'
end)

o.breakindent = true

o.tabstop = 2
o.shiftwidth = 2
o.softtabstop = 2
o.expandtab = true

o.undofile = true

o.ignorecase = true
o.smartcase = true

o.signcolumn = 'yes:1'

o.updatetime = 250
o.timeoutlen = 300

o.splitright = true
o.splitbelow = true

o.list = false
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.fillchars = {
  eob = ' ',
  vert = '│',
  fold = ' ',
  foldopen = 'v',
  foldclose = '>',
  foldsep = ' ',
  msgsep = '─',
}

o.inccommand = 'split'
o.cursorline = true
o.cursorlineopt = 'number'
o.scrolloff = 10
o.confirm = true

o.foldcolumn = '1'
o.foldlevel = 99
o.foldlevelstart = 99
o.foldenable = true
