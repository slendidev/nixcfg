return {
	"glacambre/firenvim",
	lazy = not vim.g.started_by_firenvim,
	module = false,
	build = function()
		vim.fn"firenvim#install"
	end,
}
