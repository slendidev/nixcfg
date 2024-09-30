vim.g.mapleader = ' '

vim.keymap.set('n', '<Leader>j', ':bp<CR>', { silent = true })
vim.keymap.set('n', '<Leader>k', ':bn<CR>', { silent = true })
vim.keymap.set('n', '<Leader>q', ':bd<CR>', { silent = true })
vim.keymap.set('n', '<Leader>x', vim.diagnostic.open_float)
vim.keymap.set('n', '<Leader>/', ':let @/ = ""<CR>', { silent = true }) -- Clear search

-- Move lines respecting indentation
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Nice shit
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Paste without replacing buffer
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Replace current word with something else, useful in places where <leader>R is not available
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- Chmod this bitch
vim.keymap.set("n", "<leader>X", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>c", "<cmd>silent !pandoc -t pdf main.md -o main.pdf<CR>", { silent = true })
vim.keymap.set("n", "<leader>o", "<cmd>silent !pandoc -t pdf main.md -o main.pdf && zathura main.pdf & disown<CR>", { silent = true })

-- Escape term
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { silent = true })

-- Yank the whole thing baby!
vim.keymap.set('n', '<Leader>y', ':%y<CR>')

-- Netrw my beloved
vim.keymap.set('n', '<Leader>d', ':Ex<CR>')

-- Faster buffer navigation, duplicate of <Leader>j and <Leader>k
vim.keymap.set({'n', 'i'}, '<C-J>', ':bn<CR>')
vim.keymap.set({'n', 'i'}, '<C-K>', ':bp<CR>')

vim.opt.mouse = 'a'

vim.cmd [[
	imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")
]]

-- Pop up terminal
vim.keymap.set('n', '<Leader>tt', ':ToggleTerm size=15<CR>', { silent = true })
vim.keymap.set('n', '<Leader>tf', ':ToggleTerm size=15 direction=float<CR>', { silent = true })
vim.keymap.set('n', '<Leader>ta', ':ToggleTermAll<CR>', { silent = true })

vim.keymap.set('n', '<Leader>fc', ':CdProject<CR>', { silent = true })
vim.keymap.set('n', '<Leader>fC', ':CdProjectAdd<CR>', { silent = true })

local tel = require('telescope.builtin')
vim.keymap.set('n', '<Leader>fF', tel.find_files)
vim.keymap.set('n', '<Leader>ff', tel.git_files)
vim.keymap.set('n', '<Leader>fs', tel.lsp_document_symbols)
vim.keymap.set('n', '<Leader>fg', tel.live_grep)
vim.keymap.set('n', '<Leader>fb', tel.buffers)
vim.keymap.set('n', '<Leader>fh', tel.help_tags)

vim.keymap.set('n', '<Leader>R', '<cmd>lua vim.lsp.buf.rename()<cr>')

