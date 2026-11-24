-- Keep a Claude Code terminal's size fixed when its window is resized (e.g. when the explorer opens).
-- Claude's classic renderer (see config/options.lua) redraws badly after a resize: its count of lines to
-- redraw is off (Neovim also rewraps the screen when the width changes), so earlier output gets duplicated
-- or overwritten. Neovim sizes a terminal to the largest window showing it, so each terminal gets a hidden
-- float that holds the size while Claude runs: the editor's width, and the tallest height seen (a fixed
-- full height would push Claude's input box below a shorter window). A smaller window then shows the lines
-- wrapped. Shells keep resizing normally: their float stays as small as possible.
local M = {}

-- Terminal buffer -> hidden float window
local pins = {}

local function is_pin(win)
  return pins[vim.api.nvim_win_get_buf(win)] == win
end

local function text_width(win)
  local info = vim.fn.getwininfo(win)[1]
  return info.width - info.textoff
end

--- The terminal's width as Neovim sets it: that of its widest window, the hidden float included
function M.width(buf)
  local width = 0
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    width = math.max(width, text_width(win))
  end
  return width
end

local function update(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "terminal" then
    return
  end
  local shown_height = 0
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    if not is_pin(win) then
      shown_height = math.max(shown_height, vim.api.nvim_win_get_height(win))
    end
  end

  local pin = pins[buf]
  local valid = pin ~= nil and vim.api.nvim_win_is_valid(pin)
  local width, height = 1, 1
  if require("util.foreground").foreground_comm(buf) == "claude" then
    -- Floats must fit in the editor, so resizing the Neovim window itself still resizes the terminal
    local pinned_height = valid and vim.api.nvim_win_get_height(pin) or 0
    width = vim.o.columns
    height = math.min(math.max(pinned_height, shown_height), vim.o.lines - 1)
  end

  local config = { relative = "editor", row = 0, col = 0, width = width, height = height, hide = true }
  if valid then
    if vim.api.nvim_win_get_width(pin) ~= width or vim.api.nvim_win_get_height(pin) ~= height then
      vim.api.nvim_win_set_config(pin, config)
    end
  else
    config.focusable = false
    config.noautocmd = true
    pins[buf] = vim.api.nvim_open_win(buf, false, config)
  end
end

local function update_all()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      update(buf)
    end
  end
end

function M.setup()
  local group = vim.api.nvim_create_augroup("term_size", { clear = true })
  -- The float already holds the size when a window shrinks, so updating a moment later is safe.
  -- Scheduled because WinClosed runs while the window still exists; TabClosed recreates a float that
  -- closed with its tab.
  vim.api.nvim_create_autocmd(
    { "TermOpen", "BufWinEnter", "WinNew", "WinResized", "VimResized", "WinClosed", "TabClosed" },
    {
      group = group,
      desc = "Keep Claude Code terminals at a fixed size",
      callback = vim.schedule_wrap(update_all),
    }
  )
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      pins[ev.buf] = nil
    end,
  })
  update_all()
end

return M
