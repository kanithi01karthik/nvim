-- Extend LazyVim's neo-tree config via opts
return {
	"nvim-neo-tree/neo-tree.nvim",
	opts = {
		sources = { "filesystem", "buffers", "git_status" },
		window = {
			width = 30,
			position = "left",
		},
		filesystem = {
			bind_to_cwd = true,
			follow_current_file = { enabled = true },
		},
	},
	config = function(_, opts)
		require("neo-tree").setup(opts)

		local function apply_neotree_highlights()
			local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
			local normal_nc = vim.api.nvim_get_hl(0, { name = "NormalNC", link = false })
			local cursorline = vim.api.nvim_get_hl(0, { name = "CursorLine", link = false })

			vim.api.nvim_set_hl(0, "NeoTreeNormal", { fg = normal.fg, bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { fg = normal_nc.fg or normal.fg, bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", ctermbg = "none" })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = cursorline.bg, ctermbg = cursorline.ctermbg })
		end

		local group = vim.api.nvim_create_augroup("NeoTreeThemeFix", { clear = true })

		vim.api.nvim_create_autocmd("FileType", {
			group = group,
			pattern = "neo-tree",
			callback = function()
				-- Keep neo-tree text crisp after theme switches.
				vim.wo.winblend = 0
				apply_neotree_highlights()
			end,
		})

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = group,
			callback = apply_neotree_highlights,
		})
	end,
	init = function()
		-- Open neo-tree rooted at the passed directory when starting nvim with a directory arg
		if vim.fn.argc() == 1 and vim.fn.isdirectory(vim.fn.argv(0)) == 1 then
			local dir = vim.fn.fnamemodify(vim.fn.argv(0), ":p")
			vim.schedule(function()
				vim.cmd.cd(dir)
				local ok, command = pcall(require, "neo-tree.command")
				if ok then
					command.execute({
						source = "filesystem",
						action = "show",
						dir = dir,
						position = "left",
						reveal = true,
					})
				end
			end)
		end
	end,
}
