-- Claude Code's main-screen renderer (CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN, see config/options.lua) tracks
-- cursor positions itself, so after a resize or a tab/buffer switch its output and prompt can be drawn over
-- stale lines. Sending Ctrl+L makes Claude redraw cleanly, keeping the conversation and the prompt draft.
local M = {}

local DEBOUNCE_MS = 150

-- Name of the foreground process on the terminal's pty, so Claude is found also when started from a shell
function M.foreground_comm(buf)
  local pid = vim.b[buf].terminal_job_pid
  local stat = pid and io.open("/proc/" .. pid .. "/stat")
  if not stat then
    return nil
  end
  local line = stat:read("*l")
  stat:close()
  -- Fields after "(comm)": state ppid pgrp session tty_nr tpgid
  local tpgid = line:match("%) %S+ %S+ %S+ %S+ %S+ (%d+)")
  local comm = tpgid and io.open("/proc/" .. tpgid .. "/comm")
  if not comm then
    return nil
  end
  local name = comm:read("*l")
  comm:close()
  return name
end

local pending = {}

local function redraw_later(buf)
  if pending[buf] then
    return
  end
  pending[buf] = true
  vim.defer_fn(function()
    pending[buf] = nil
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buftype == "terminal" and M.foreground_comm(buf) == "claude" then
      vim.api.nvim_chan_send(vim.bo[buf].channel, "\12")
    end
  end, DEBOUNCE_MS)
end

local function redraw_visible_terminals()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      redraw_later(buf)
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("claude_redraw", { clear = true })
  vim.api.nvim_create_autocmd({ "WinResized", "VimResized", "TabEnter", "BufWinEnter" }, {
    group = group,
    desc = "Redraw Claude Code terminals after their size or visibility changes",
    callback = redraw_visible_terminals,
  })
end

return M
