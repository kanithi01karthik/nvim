-- ╭─────────────────────────────────────╮
-- │           General / Global          │
-- ╰─────────────────────────────────────╯
-- NOTE: <leader>w is LazyVim's window-group prefix; use <C-s> to save instead.
-- LazyVim already maps <C-s> to save; the line below is kept as a personal alias.
vim.keymap.set("n", "<leader>W", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>xr", ":%s///gI<Left><Left><Left>", { desc = "Find and replace in file" })

-- ╭─────────────────────────────────────╮
-- │     Move / Copy Lines Up & Down     │
-- ╰─────────────────────────────────────╯
-- Move lines
vim.keymap.set("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move line up" })
vim.keymap.set("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move line down" })
vim.keymap.set("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Copy/Duplicate lines
vim.keymap.set("n", "<S-A-j>", ":t.<CR>", { desc = "Copy line down" })
vim.keymap.set("n", "<S-A-k>", ":t-1<CR>", { desc = "Copy line up" })
vim.keymap.set("v", "<S-A-j>", ":t '><CR>gv=gv", { desc = "Copy selection down" })
vim.keymap.set("v", "<S-A-k>", ":t '<-1<CR>gv=gv", { desc = "Copy selection up" })

-- ╭─────────────────────────────────────╮
-- │                LSP                  │
-- ╰─────────────────────────────────────╯
-- LazyVim already maps: K (hover), gd (definition), gr (references),
-- <leader>cr (rename), <leader>ca (code action), <leader>cd (line diagnostics),
-- [d / ]d (prev/next diagnostic), <leader>cf (format).
-- Only add keymaps here that LazyVim does NOT provide.

-- ╭─────────────────────────────────────╮
-- │           Telescope                 │
-- ╰─────────────────────────────────────╯
-- LazyVim already maps core Telescope finders.
-- Only add the custom ast-grep picker here.
vim.keymap.set("n", "<leader>sg", function()
	require("telescope.builtin").live_grep()
end, { desc = "Search text in files" })
local telescope = require("utils.telescope")
vim.keymap.set("n", "<leader>ag", telescope.extension("ast_grep", "ast_grep"), { desc = "Telescope ast-grep" })
-- ╭─────────────────────────────────────╮
-- │           Neo-tree / Oil            │
-- ╰─────────────────────────────────────╯
-- LazyVim maps <leader>e / <leader>E for neo-tree.
-- <C-n> is kept as an additional personal shortcut.
vim.keymap.set("n", "<C-n>", ":Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

-- Key debug: capture raw bytes for a pressed key (useful for diagnosing Ctrl sequences)
vim.keymap.set("n", "<leader>kk", require("utils.keydebug").capture, { desc = "Capture raw key bytes" })

-- ╭─────────────────────────────────────╮
-- │         Mouse Keybindings           │
-- ╰─────────────────────────────────────╯
-- Disable middle click paste in Normal/Insert mode
vim.keymap.set("n", "<MiddleMouse>", "<LeftMouse>")
vim.keymap.set("i", "<MiddleMouse>", "<LeftMouse>")
-- Optionally disable double/triple clicks too
vim.keymap.set("n", "<2-MiddleMouse>", "<2-LeftMouse>")
vim.keymap.set("n", "<3-MiddleMouse>", "<3-LeftMouse>")

-- ╭─────────────────────────────────────╮
-- │          Plugin Keybindings         │
-- ╰─────────────────────────────────────╯
-- Ollama chat
vim.keymap.set("n", "<leader>oo", ":Gen<CR>", { desc = "Ollama chat" })
vim.keymap.set("v", "<leader>oo", ":Gen<CR>", { desc = "Ollama chat (selection)" })

-- Code Runner
vim.keymap.set("n", "<leader>rr", "<cmd>w<CR><cmd>RunCode<CR>", { desc = "Save and run code" })
vim.keymap.set("n", "<leader>rt", function()
	if _G.toggle_code_runner_mode then
		_G.toggle_code_runner_mode()
	else
		vim.notify("Code Runner is not initialized yet", vim.log.levels.WARN)
	end
end, { silent = true, desc = "Toggle Code Runner mode" })

-- Copilot
vim.keymap.set("i", "<C-J>", 'copilot#Accept("\\<Tab>")', { expr = true, replace_keycodes = false, silent = true })
vim.keymap.set("n", "<leader>ct", function()
	if vim.g.copilot_enabled == nil then
		vim.g.copilot_enabled = true
	end
	if vim.g.copilot_enabled then
		vim.cmd("Copilot disable")
	else
		vim.cmd("Copilot enable")
	end
	vim.cmd("Copilot status")
end, { silent = true, desc = "Toggle Copilot" })
vim.keymap.set("i", "<leader>cp", 'copilot#Accept("\\<Tab>")', { expr = true, replace_keycodes = false, silent = true })
vim.keymap.set("n", "<leader>cp", function()
	vim.cmd("startinsert")
	vim.cmd('call copilot#Accept("\\<Tab>")')
end, { desc = "Accept Copilot suggestion", silent = true })

-- Antigravity Chat
vim.keymap.set("n", "<leader>ac", function()
	require("utils.antigravity").toggle_antigravity_chat()
end, { silent = true, desc = "Toggle Antigravity Chat" })

-- ╭─────────────────────────────────────╮
-- │       Shortcuts from mu-vim         │
-- ╰─────────────────────────────────────╯
vim.keymap.set("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlight", silent = true })
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically", silent = true })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally", silent = true })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size", silent = true })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split", silent = true })
vim.keymap.set("v", "<", "<gv", { desc = "Indent block left", silent = true })
vim.keymap.set("v", ">", ">gv", { desc = "Indent block right", silent = true })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode", silent = true })
