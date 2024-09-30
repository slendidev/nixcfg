-- Turn off default syntax highlighting
vim.cmd('syntax off')

-- Set color scheme
vim.g.colors_name = 'nobs'

-- Terminal color settings
vim.opt.termguicolors = true
vim.cmd [[ set t_Co=0 ]]
vim.cmd [[ set termguicolors ]]
vim.cmd [[ syntax enable ]]

-- Highlight configurations
vim.cmd [[
hi LineNr NONE
hi Normal guifg=#ffffff guibg=#00000000
hi NonText guifg=#333333 guibg=#00000000
hi Comment guifg=#888888
hi Identifier NONE
hi Error NONE
hi Type NONE
hi PreProc NONE
hi Constant NONE
hi Statement NONE
hi Directory NONE
hi Special NONE
hi Constant NONE
hi Underlined NONE
hi Title NONE
hi String NONE
hi Function NONE
hi MatchParen guibg=#222222

hi NormalFloat guibg=#00000000

hi link DiagnosticFloatingError Normal
hi link DiagnosticFloatingWarn Normal
hi link DiagnosticFloatingInfo Normal
hi link DiagnosticFloatingHint Normal

hi Search guibg=#333333 guifg=#ffffff
hi Visual guibg=#555555 guifg=#ffffff

hi Pmenu guibg=#222222 guifg=#ffffff
hi PmenuSel guibg=#333333 guifg=#ffffff

hi DiagnosticError guifg=#333333
hi DiagnosticWarn guifg=#333333
hi DiagnosticInfo guifg=#333333
hi DiagnosticHint guifg=#333333

hi DiagnosticUnderlineError guisp=#333333
hi DiagnosticUnderlineWarn guisp=#333333
hi DiagnosticUnderlineInfo guisp=#333333
hi DiagnosticUnderlineHint guisp=#333333

hi StatusLine guifg=#222222 guibg=#ffffff
hi DiffAdd NONE

hi QuickScopePrimary gui=bold guifg=#999999
hi QuickScopeSecondary gui=italic,bold guifg=#999999

hi Operator guifg=#999999
hi Delimiter guifg=#999999

augroup AlwaysHighlight
  autocmd!
  autocmd BufReadPost * source ~/.config/nvim/after/syntax/custom.vim
augroup END
]]

-- Editor behaviors
vim.opt.list = true
vim.opt.listchars = { trail = '·', tab = '  ' }


