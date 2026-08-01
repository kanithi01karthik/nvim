return {
	"ajbucci/ipynb.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"neovim/nvim-lspconfig",
		"nvim-tree/nvim-web-devicons",
		"folke/snacks.nvim",
		{
			"MeanderingProgrammer/render-markdown.nvim",
			ft = { "markdown", "ipynb" },
			opts = {
				overrides = {
					filetype = {
						ipynb = {
							anti_conceal = { enabled = false },
						},
					},
				},
			},
		},
	},
	-- No lazy loading (lazy=false implicitly) so it can intercept BufReadCmd for *.ipynb
	opts = {
		kernel = {
			python_executable = "python3", -- The python used to start the Jupyter kernel
			show_status = true,
		},
		output = {
			max_height = 20, -- Maximum height of the output window
			render_images = true, -- Requires snacks.image to be enabled in snacks.nvim!
			image_provider = "snacks",
		},
		hover = {
			auto_hover = true, -- Show variable inspection on hover
			delay = 500,
		},
		format = {
			enabled = true, -- Wrap vim.lsp.buf.format() to format notebooks
			trailing_blank_lines = 0,
		},
		shadow = {
			location = "temp", -- "temp" or "workspace" (workspace helps with LSP project contexts)
		},
	},
}
