local M = {}

local fallback_win = nil
local fallback_buf = nil
local fallback_job_id = nil

-- Kill the terminal job and clean up fallback buffers so :wqa / :qa work without E948
local function cleanup_fallback()
	if fallback_job_id then
		pcall(vim.fn.jobstop, fallback_job_id)
		fallback_job_id = nil
	end
	if fallback_buf and vim.api.nvim_buf_is_valid(fallback_buf) then
		pcall(vim.api.nvim_buf_delete, fallback_buf, { force = true })
		fallback_buf = nil
	end
	fallback_win = nil
end

vim.api.nvim_create_autocmd("QuitPre", {
	callback = function()
		if fallback_buf and vim.api.nvim_buf_is_valid(fallback_buf) then
			cleanup_fallback()
		end
	end,
})

-- Helper to list WezTerm panes
local function get_wezterm_panes()
	local handle = io.popen("wezterm cli list --format json 2>/dev/null")
	if not handle then
		return nil
	end
	local result = handle:read("*a")
	handle:close()
	if not result or result == "" then
		return nil
	end
	local ok, decoded = pcall(vim.fn.json_decode, result)
	if not ok then
		return nil
	end
	return decoded
end

function M.toggle_fallback_chat()
	-- If window is valid and open, close it (but keep the buffer alive for reuse)
	if fallback_win and vim.api.nvim_win_is_valid(fallback_win) then
		vim.api.nvim_win_close(fallback_win, true)
		fallback_win = nil
		return
	end

	-- If buffer doesn't exist or is invalid, create a new one
	if not fallback_buf or not vim.api.nvim_buf_is_valid(fallback_buf) then
		fallback_buf = vim.api.nvim_create_buf(false, true)
		vim.bo[fallback_buf].bufhidden = "hide"
		vim.bo[fallback_buf].buflisted = false
	end

	-- Split vertically on the right
	vim.cmd("botright vertical split")
	fallback_win = vim.api.nvim_get_current_win()
	vim.api.nvim_win_set_buf(fallback_win, fallback_buf)

	-- Set sidepane width (30% of screen columns, min 45 columns)
	local width = math.max(45, math.floor(vim.o.columns * 0.3))
	vim.api.nvim_win_set_width(fallback_win, width)

	-- Disable line numbers and sign column in the chat window
	vim.wo[fallback_win].number = false
	vim.wo[fallback_win].relativenumber = false
	vim.wo[fallback_win].signcolumn = "no"
	vim.wo[fallback_win].cursorline = false
	vim.wo[fallback_win].scrolloff = 0

	-- Check if terminal is already running in the buffer
	if vim.bo[fallback_buf].buftype ~= "terminal" then
		-- Run `agy` inside the buffer
		fallback_job_id = vim.fn.termopen("agy", {
			on_exit = function()
				fallback_job_id = nil
				vim.schedule(function()
					if fallback_win and vim.api.nvim_win_is_valid(fallback_win) then
						vim.api.nvim_win_close(fallback_win, true)
						fallback_win = nil
					end
					if fallback_buf and vim.api.nvim_buf_is_valid(fallback_buf) then
						vim.api.nvim_buf_delete(fallback_buf, { force = true })
						fallback_buf = nil
					end
				end)
			end,
		})
	end

	vim.bo[fallback_buf].filetype = "antigravity-chat"

	-- Bind keymap to toggle inside the terminal buffer (terminal mode)
	vim.keymap.set("t", "<leader>ac", function()
		M.toggle_antigravity_chat()
	end, { buffer = fallback_buf, silent = true, desc = "Toggle Antigravity Chat" })

	-- Start in terminal mode automatically
	vim.cmd("startinsert")
end

function M.toggle_antigravity_chat()
	local current_pane_id = tonumber(os.getenv("WEZTERM_PANE"))
	if not current_pane_id then
		-- Fallback to Neovim built-in terminal split if not in WezTerm
		M.toggle_fallback_chat()
		return
	end

	local panes = get_wezterm_panes()
	if not panes then
		M.toggle_fallback_chat()
		return
	end

	-- Find our current tab_id
	local current_tab_id = nil
	for _, pane in ipairs(panes) do
		if pane.pane_id == current_pane_id then
			current_tab_id = pane.tab_id
			break
		end
	end

	if not current_tab_id then
		M.toggle_fallback_chat()
		return
	end

	-- Check if there is an agy pane in the same tab
	local agy_pane_id = nil
	for _, pane in ipairs(panes) do
		if pane.tab_id == current_tab_id and (pane.title == "agy" or string.match(pane.title, "^agy")) then
			agy_pane_id = pane.pane_id
			break
		end
	end

	if agy_pane_id then
		-- Close the existing agy pane
		vim.fn.system(string.format("wezterm cli kill-pane --pane-id %d", agy_pane_id))
	else
		-- Open a new agy pane on the right side
		vim.fn.system("wezterm cli split-pane --right --percent 30 agy")
	end
end

return M
