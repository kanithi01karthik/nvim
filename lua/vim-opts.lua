-- LazyVim already provides: expandtab, tabstop=2, shiftwidth=2, number,
-- relativenumber, signcolumn, clipboard, foldcolumn.
-- Only set options that differ from or extend LazyVim defaults here.

vim.opt.wildignorecase = true
vim.opt.signcolumn = "yes:1" -- extra column padding beyond LazyVim default

-- Use the OS clipboard for yanks/pastes in both directions (+ register).
vim.opt.clipboard = "unnamedplus"

-- Keep popups/floats opaque.
vim.opt.pumblend = 0
vim.opt.winblend = 0

local function set_ui_opacity()
	-- Keep only the main editor background transparent.
	vim.api.nvim_set_hl(0, "Normal", { bg = "none", ctermbg = "none" })
	vim.api.nvim_set_hl(0, "NormalNC", { bg = "none", ctermbg = "none" })

	-- Force floating/pop-up UI (Lazy, Mason, cmp, etc.) to be opaque.
	local pmenu = vim.api.nvim_get_hl(0, { name = "Pmenu", link = false })
	local float_bg = pmenu.bg or 0x1E1E1E
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = float_bg })
	vim.api.nvim_set_hl(0, "FloatBorder", { bg = float_bg })
	vim.api.nvim_set_hl(0, "Pmenu", { bg = float_bg })
	vim.api.nvim_set_hl(0, "PmenuSel", { bg = float_bg })
end

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = set_ui_opacity,
})

set_ui_opacity()
vim.opt.background = "dark"
