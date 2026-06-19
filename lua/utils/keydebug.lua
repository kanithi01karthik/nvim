local M = {}

local function hex(b) return string.format("0x%02X", b) end

function M.capture()
  vim.notify("Press the key to capture (Esc to cancel)")
  local ok, ch = pcall(vim.fn.getcharstr)
  if not ok or not ch or ch == "" then
    vim.notify("No input captured", vim.log.levels.WARN)
    return
  end
  if ch == vim.api.nvim_replace_termcodes("<Esc>", true, false, true) then
    vim.notify("Cancelled", vim.log.levels.INFO)
    return
  end

  local bytes = { string.byte(ch, 1, #ch) }
  local parts = {}
  for i, b in ipairs(bytes) do
    parts[#parts+1] = string.format("%d(%s)", b, hex(b))
  end
  local msg = string.format("Captured: %q  bytes: %s", ch, table.concat(parts, ", "))
  vim.notify(msg)
end

return M
