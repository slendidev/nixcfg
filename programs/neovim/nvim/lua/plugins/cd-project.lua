return {
	{
		'LintaoAmons/cd-project.nvim',
		config = function()
			require('cd-project').setup {
				projects_config_filepath = vim.fs.normalize(vim.fn.stdpath('config') .. '/cd-project.nvim.json'),
				project_dir_pattern = { '.git', '.gitignore', 'Cargo.toml', 'package.json', 'go.mod', 'CMakeLists.txt', 'init.lua', 'Makefile' },
				choice_format = 'both',
				projects_picker = 'telescope',
				hooks = {
					{
						callback = function(_)
							vim.cmd('Telescope find_files')
						end
					}
				}
			}
		end
	}
}

