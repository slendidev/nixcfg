return {
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			'saghen/blink.cmp',
			dependencies = 'rafamadriz/friendly-snippets',
			version = '*',
			opts = {
				keymap = {
					preset = 'default',

					['<Up>'] = { 'fallback' },
					['<Down>'] = { 'fallback' },

					['<Tab>'] = { 'select_next', 'fallback' },
					['<S-Tab>'] = { 'select_prev', 'fallback' },

					['<C-j>'] = { 'select_next', 'fallback' },
					['<C-k>'] = { 'select_prev', 'fallback' },

					['<C-Enter>'] = { 'accept', 'fallback' },
				},

				appearance = {
					use_nvim_cmp_as_default = true,
					nerd_font_variant = 'mono'
				},

				sources = {
					default = { 'lsp', 'path', 'snippets', 'buffer' },
				},

				fuzzy = {
					prebuilt_binaries = {
						download = true,
						force_version='v0.11.0',
					},
				}
			},
			opts_extend = { "sources.default" }
		},
		config = function()
			local blink = require'blink.cmp'

			vim.api.nvim_create_autocmd('BufWritePre', {
				command = 'lua vim.lsp.buf.format()',
				pattern = '*'
			})

			local lspconfig = require 'lspconfig'
			local function config(_config)
				local cap = blink.get_lsp_capabilities(vim.lsp.protocol.make_client_capabilities())
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

