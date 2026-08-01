return {
	"goerz/jupytext.vim",
	init = function()
		-- Converts .ipynb to python files using the # %% percent format when opened
		-- When you save the file, it automatically updates the .ipynb file
		vim.g.jupytext_fmt = "py:percent"
		
		-- Optional: disable jupytext's default appending of its own metadata
		vim.g.jupytext_print_time = false
	end,
}
