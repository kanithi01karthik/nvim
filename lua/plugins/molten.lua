return {
	"benlubas/molten-nvim",
	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	dependencies = { "3rd/image.nvim" },
	build = ":UpdateRemotePlugins",
	init = function()
		-- Molten configuration
		vim.g.molten_image_provider = "image.nvim"
		vim.g.molten_output_win_max_height = 20
		
		-- Make it feel more like a notebook (inline output)
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
		vim.g.molten_image_location = "virt"
		vim.g.molten_auto_open_output = false
	end,
}
