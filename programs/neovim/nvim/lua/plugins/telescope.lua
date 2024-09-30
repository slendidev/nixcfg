return {
	{
		"nvim-telescope/telescope.nvim",
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-file-browser.nvim',
				event = 'VeryLazy',
				dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' } 
			}
		},
		keys = {
			{
				'<leader>ff',
				mode = 'n',
				function() require('telescope.builtin').git_files() end
			},
			{
				'<leader>fF',
				mode = 'n',
				function() require('telescope.builtin').find_files() end
			},
			{
				'<leader>fg',
				mode = 'n',
				function() require('telescope.builtin').live_grep() end
			},
			{
				'<leader>fs',
				mode = 'n',
				function() require('telescope.builtin').treesitter() end
			},
			{
				'<leader>fb',
				mode = 'n',
				function() require('telescope.builtin').buffers() end
			}
		},
		config = function()
			require('telescope').setup {}
		end
	}
}

