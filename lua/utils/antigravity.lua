local M = {}
local chat_win = nil
local chat_buf = nil

function M.toggle_antigravity_chat()
	-- If window is valid and open, close it
	if chat_win and vim.api.nvim_win_is_valid(chat_win) then
		vim.api.nvim_win_close(chat_win, true)
		chat_win = nil
		return
	end

	-- If buffer doesn't exist or is invalid, create a new one
	if not chat_buf or not vim.api.nvim_buf_is_valid(chat_buf) then
		chat_buf = vim.api.nvim_create_buf(false, true)
		vim.bo[chat_buf].bufhidden = "hide"
	end

	-- Split vertically on the right
	vim.cmd("botright vertical split")
	chat_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(chat_win, chat_buf)

	-- Set sidepane width (30% of screen columns, min 45 columns)
	local width = math.max(45, math.floor(vim.o.columns * 0.3))
	vim.api.nvim_win_set_width(chat_win, width)

	-- Check if terminal is already running in the buffer
	if vim.bo[chat_buf].buftype ~= "terminal" then
		-- Run `agy` inside the buffer
		vim.fn.termopen("agy")

		-- When the terminal exits, close the window and delete buffer
		vim.api.nvim_create_autocmd("TermClose", {
			buffer = chat_buf,
			callback = function()
				if chat_win and vim.api.nvim_win_is_valid(chat_win) then
					vim.api.nvim_win_close(chat_win, true)
					chat_win = nil
				end
				if chat_buf and vim.api.nvim_buf_is_valid(chat_buf) then
					vim.api.nvim_buf_delete(chat_buf, { force = true })
					chat_buf = nil
				end
			end,
		})
	end

	vim.bo[chat_buf].filetype = "antigravity-chat"

	-- Bind keymap to toggle inside the terminal buffer (terminal mode)
	vim.keymap.set("t", "<leader>cc", function()
		M.toggle_antigravity_chat()
	end, { buffer = chat_buf, silent = true, desc = "Toggle Antigravity Chat" })

	-- Start in terminal mode automatically
	vim.cmd("startinsert")
end

return M
