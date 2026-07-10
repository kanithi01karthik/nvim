return {
	"github/copilot.vim",
	config = function()
		-- enable Copilot by default
		vim.g.copilot_enabled = false

		-- don't let Copilot map <Tab> automatically (we'll map a key ourselves)
		vim.g.copilot_no_tab_map = true
	end,
}
