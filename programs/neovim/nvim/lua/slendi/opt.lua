vim.api.nvim_buf_set_option(0, 'fileformat', 'unix')
vim.api.nvim_exec([[
	augroup VimFiletypeUnix
	autocmd!
		autocmd FileType vim setlocal fileformat=unix
	augroup END
]], false)

vim.o.number = true
vim.o.relativenumber = true

vim.o.scrolloff = 2

vim.o.spelllang = 'ro,en'

vim.cmd [[
	setlocal spell
	inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u
]]

--vim.g.copilot_enabled = 0
--vim.cmd("Copilot disable")

-- If the file is a text file, enable copilot and enable spellchecking
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	pattern = "*",
	callback = function()
		local filetype = vim.bo.filetype
		if filetype ~= "text" and filetype ~= "markdown" then
			--vim.g.copilot_enabled = 1
			vim.cmd("set nospell")
			--vim.cmd("Copilot enable")
		else
		end
	end
})

-- Tab size
vim.o.tabstop = 2
vim.o.softtabstop = vim.o.tabstop
vim.o.shiftwidth = vim.o.softtabstop
vim.o.expandtab = false

vim.o.incsearch = true
vim.o.ignorecase = true

vim.o.smartindent = true

vim.o.wrap = true

-- Some people don't like this, but having it as system clipboard makes shit blazingly fast
vim.o.clipboard = 'unnamedplus'

vim.o.splitbelow = true
vim.o.splitright = true

vim.g.netrw_style = 'tree'

vim.o.signcolumn = 'number'

if vim.g.nvui then
  -- Configure through vim commands
  vim.cmd [[NvuiCmdFontFamily FiraCode Nerd Font Mono]]
end

vim.o.guifont = 'FiraCode Nerd Font Mono:h14'

vim.g.conceallevel = 1

vim.g.neovide_padding_top = 10
vim.g.neovide_padding_bottom = 10
vim.g.neovide_padding_right = 10
vim.g.neovide_padding_left = 10

vim.g.neovide_transparency = 0.8

