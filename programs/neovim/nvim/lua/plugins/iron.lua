return {
	'Vigemus/iron.nvim',
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")

		iron.setup {
			config = {
				scratch_repl = true,
				repl_definition = {
					python = {
						command = function(meta)
							-- Prompt user for the name of the class to create with Manim
							local input = vim.fn.input("Manim Class: ", "CreateCircle")
							-- Return the Manim command
							return {
								"manim",
								"-qm",
								"-p",
								"--renderer=opengl",
								"main.py",
								input
							}
						end,
					},
				},
				-- Open REPL in a vertical split
				repl_open_cmd = view.split.vertical.botright(50),
			},
			keymaps = {
				send_motion = "<leader>sc",
				visual_send = "<leader>sc",
				send_file = "<leader>sf",
				send_line = "<leader>sl",
				send_paragraph = "<leader>sp",
				send_until_cursor = "<leader>su",
				send_mark = "<leader>sm",
				mark_motion = "<leader>mc",
				mark_visual = "<leader>mc",
				remove_mark = "<leader>md",
				cr = "<leader>s<cr>",
				interrupt = "<leader>s<space>",
				exit = "<leader>sq",
				clear = "<leader>cl",
			},
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true,
		}

		-- Keymaps for managing the REPL window
		vim.keymap.set('n', '<leader>rs', '<cmd>IronRepl<cr>')
		vim.keymap.set('n', '<leader>rr', '<cmd>IronRestart<cr>')
		vim.keymap.set('n', '<leader>rf', '<cmd>IronFocus<cr>')
		vim.keymap.set('n', '<leader>rh', '<cmd>IronHide<cr>')
	end
}
