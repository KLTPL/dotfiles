-- Keep a running Claude Code's terminal from shrinking when its window does (e.g. when the explorer opens) or
-- when another buffer takes its window.
-- Claude's classic renderer (see config/options.lua) redraws badly after its terminal resizes: its count of
-- lines to redraw is off, so earlier output gets duplicated or overwritten and typing can land on the wrong row.
-- Neovim sizes a terminal to the largest window showing it, and keeps the size while none does. So while
-- Claude runs, its terminal gets a hidden float holding the size it has: a smaller window then shows the lines
-- wrapped. A larger window still enlarges the terminal (the float then grows along). Other terminals get no
-- float and resize as usual.
local M = {}

-- Terminal buffer -> hidden float window, only while Claude runs in it
local pins = {}

-- Terminal buffer -> loop time (ms) until which it counts as running Claude
local held = {}
-- Enter on a `claude` command line holds the size this long, covering the start until Claude is the
-- foreground process; a command that only mentioned claude is then released
local HOLD_MS = 2000

local SHELLS = { zsh = true, bash = true, sh = true, fish = true }

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

local function release(buf)
  local pin = pins[buf]
  pins[buf] = nil
  if pin and vim.api.nvim_win_is_valid(pin) then
    vim.api.nvim_win_close(pin, true)
  end
end

local function update(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].buftype ~= "terminal" then
    return
  end
  if require("util.foreground").foreground_comm(buf) ~= "claude" and (held[buf] or 0) <= vim.uv.now() then
    release(buf)
    return
  end

  -- The terminal's size: that of its largest window, the float included
  local width, height = 0, 0
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    width = math.max(width, text_width(win))
    height = math.max(height, vim.api.nvim_win_get_height(win))
  end
  -- Not shown anywhere and no float yet: Neovim keeps the size until a window shows it
  if width < 1 or height < 1 then
    return
  end
  -- Floats must fit in the editor, so shrinking the Neovim window itself still shrinks the terminal
  width = math.min(width, vim.o.columns)
  height = math.min(height, vim.o.lines - 1)

  local pin = pins[buf]
  local config = { relative = "editor", row = 0, col = 0, width = width, height = height, hide = true }
  if pin and vim.api.nvim_win_is_valid(pin) then
    if vim.api.nvim_win_get_width(pin) ~= width or vim.api.nvim_win_get_height(pin) ~= height then
      vim.api.nvim_win_set_config(pin, config)
    end
  else
    config.focusable = false
    config.noautocmd = true
    pins[buf] = vim.api.nvim_open_win(buf, false, config)
  end
end

-- The command line at the cursor, with the rows the terminal wrapped it into (all but the last are full) joined
local function command_line(buf)
  local width = M.width(buf)
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local text = vim.api.nvim_get_current_line()
  while row > 1 do
    local prev = vim.api.nvim_buf_get_lines(buf, row - 2, row - 1, true)[1]
    -- A space at the wrap point may be trimmed from the end of the row
    if vim.fn.strdisplaywidth(prev) < width - 1 then
      break
    end
    text = prev .. text
    row = row - 1
  end
  return text
end

-- Enter in a shell: when the command line runs claude, hold the terminal's size before Claude starts, so no
-- window change can resize it before the next window event notices Claude
local function map_enter(buf)
  vim.keymap.set("t", "<CR>", function()
    local fg = require("util.foreground").foreground_comm(buf)
    if SHELLS[fg] and command_line(buf):find("%f[%w]claude%f[%W]") then
      held[buf] = vim.uv.now() + HOLD_MS
      update(buf)
      vim.defer_fn(function()
        update(buf)
      end, HOLD_MS + 100)
    end
    vim.api.nvim_feedkeys(vim.keycode("<CR>"), "n", false)
  end, { buffer = buf, desc = "Enter (keeps a starting Claude Code at its size)" })
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
      desc = "Keep Claude Code terminals from shrinking",
      callback = vim.schedule_wrap(update_all),
    }
  )
  vim.api.nvim_create_autocmd("TermOpen", {
    group = group,
    desc = "Hold the size of a Claude Code started from a shell",
    callback = function(ev)
      map_enter(ev.buf)
    end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(ev)
      pins[ev.buf] = nil
      held[ev.buf] = nil
    end,
  })
  -- Terminals opened at startup (e.g. by cnvim) exist before this runs on VeryLazy
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      map_enter(buf)
    end
  end
  update_all()
end

return M
