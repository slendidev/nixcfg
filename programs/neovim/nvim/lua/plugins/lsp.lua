return {
	{
		'neovim/nvim-lspconfig',
		config = function()
			vim.api.nvim_create_autocmd('BufWritePre', {
				command = 'lua vim.lsp.buf.format()',
				pattern = '*'
			})

			local lspconfig = require 'lspconfig'
			local function config(_config)
				local cap = vim.lsp.protocol.make_client_capabilities()
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

			local servers = { 'clangd', 'rust_analyzer', 'pyright', 'ts_ls', 'emmet_ls', 'eslint', 'gopls', 'ols', 'jdtls', 'zls', 'svelte', 'omnisharp', 'svls', 'hls' }
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

