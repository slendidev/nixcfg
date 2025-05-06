return {
	"glacambre/firenvim",
	lazy = not vim.g.started_by_firenvim,
	module = false,
	build = function()
		vim.cmd"call firenvim#install(0)"
	end,
}
