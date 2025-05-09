return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			--'saghen/blink.cmp',
			'ms-jpq/coq_nvim',
			dependencies = 'rafamadriz/friendly-snippets',
			version = '*',

			config = function(_, opts)
				vim.g.coq_settings = {
					keymap = {
						recommended = false,
					},
					auto_start = true,
				}

				local opts = { expr = true, silent = true }

				-- exit to normal, even if menu open
				vim.api.nvim_set_keymap('i', '<Esc>',
					[[pumvisible() ? "\<C-e><Esc>" : "\<Esc>"]],
					opts)

				-- abort completion
				vim.api.nvim_set_keymap('i', '<C-c>',
					[[pumvisible() ? "\<C-e><C-c>" : "\<C-c>"]],
					opts)

				-- backspace always
				vim.api.nvim_set_keymap('i', '<BS>',
					[[pumvisible() ? "\<C-e><BS>"  : "\<BS>"]],
					opts)

				-- delete word before cursor
				vim.api.nvim_set_keymap('i', '<C-w>',
					[[pumvisible() ? "\<C-e><C-w>" : "\<C-w>"]],
					opts)

				-- delete all before cursor
				vim.api.nvim_set_keymap('i', '<C-u>',
					[[pumvisible() ? "\<C-e><C-u>" : "\<C-u>"]],
					opts)

				-- <CR> selects if menu open, else normal enter
				vim.api.nvim_set_keymap('i', '<CR>',
					[[pumvisible() 
					and (vim.fn.complete_info().selected == -1 
					and "\<C-e><CR>" 
					or "\<C-y>") 
					or "\<CR>"]],
					opts)

				-- tab/shift-tab to navigate menu
				vim.api.nvim_set_keymap('i', '<Tab>',
					[[pumvisible() ? "\<C-n>" : "\<Tab>"]],
					opts)
				vim.api.nvim_set_keymap('i', '<S-Tab>',
					[[pumvisible() ? "\<C-p>" : "\<BS>"]],
					opts)

				require'coq'
			end,
		},
		config = function()
			local coq = require'coq'

			vim.api.nvim_create_autocmd('BufWritePre', {
				command = 'lua vim.lsp.buf.format()',
				pattern = '*'
			})

			local lspconfig = require 'lspconfig'
			local function config(_config)
				local cap = coq.lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities())
				return vim.tbl_deep_extend('force', {
					completion = {
						keyword_length = 0,
						autocomplete = false
					},
					on_attach = function(client, buffer)
						vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { silent = true })
						vim.keymap.set('n', 'K', function() vim.lsp.buf.hover() end, { silent = true })
						vim.keymap.set('n', '<leader>vws', function() vim.lsp.buf.workspace_symbol() end, { silent = true })
						vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { silent = true })
						vim.keymap.set('n', 'gd', function() vim.lsp.buf.definition() end, { silent = true })
						vim.keymap.set('n', "[d", function() vim.diagnostic.goto_next() end, { silent = true })
						vim.keymap.set('n', "]d", function() vim.diagnostic.goto_prev() end, { silent = true })
						vim.keymap.set('n', "<leader>vca", function() vim.lsp.buf.code_action() end, { silent = true })
						vim.keymap.set('n', "<leader>vrr", function() vim.lsp.buf.references() end, { silent = true })
						vim.keymap.set('n', "<leader>vrn", function() vim.lsp.buf.rename() end, { silent = true })
						vim.keymap.set('i', "<C-h>", function() vim.lsp.buf.signature_help() end, { silent = true })
					end
				}, _config or { })
			end

			local servers = { 'clangd', 'rust_analyzer', 'pyright', 'ts_ls', 'emmet_ls', 'eslint', 'gopls', 'ols', 'jdtls', 'zls', 'svelte', 'omnisharp', 'svls', 'hls', 'fsautocomplete', 'nil_ls' }
			for _, lsp in ipairs(servers) do
				local conf = config()
				if lsp == 'emmet_ls' then
					conf.filetypes = { 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' }
				end
				lspconfig[lsp].setup(conf)
			end

			vim.cmd('sign define DiagnosticSignError text=☢ texthl=DiagnosticSignError')
			vim.cmd('sign define DiagnosticSignWarn text=☢ texthl=DiagnosticSignWarn')
			vim.cmd('sign define DiagnosticSignInfo text=☢ texthl=DiagnosticSignInfo')
			vim.cmd('sign define DiagnosticSignHint text=☢ texthl=DiagnosticSignHint')

			vim.diagnostic.config({virtual_lines=true})
		end
	}
}

