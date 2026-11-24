-- gy in visual mode in terminal buffers: yank text from a TUI (mainly Claude Code) without its layout.
-- Claude indents its output and hard-wraps it at the terminal width, so a plain yank copies both.
--   v / V:  drop the shared indent and the "⏺" bullet, and join lines Claude wrapped
--   <C-v>:  for one table cell: trim each line and its "│" borders, join the lines with spaces
local M = {}

-- Cells Claude leaves free at the right edge; a line whose next word would not have fit within the
-- width minus this was wrapped there. Joining only uses this test, so code and lists keep their breaks.
local WRAP_SLACK = 4

local function rtrim(s)
  return (s:gsub("%s+$", ""))
end

local function ltrim(s)
  return (s:gsub("^%s+", ""))
end

local function indent(s)
  return #s:match("^ *")
end

--- Whether `prev` (a whole buffer line) ends where Claude wrapped it, given the line after it
local function wrapped(prev, next, width)
  local word = ltrim(next):match("^%S+")
  if rtrim(prev) == "" or not word then
    return false
  end
  return vim.fn.strdisplaywidth(rtrim(prev)) + 1 + vim.fn.strdisplaywidth(word) > width - WRAP_SLACK
end

--- Text of a block (<C-v>) selection: one table cell spread over several lines
function M.clean_block(lines)
  local parts = {}
  for _, line in ipairs(lines) do
    local part = vim.trim(line:gsub("^[%s│|]+", ""):gsub("[%s│|]+$", ""))
    if part ~= "" then
      table.insert(parts, part)
    end
  end
  return table.concat(parts, " ")
end

--- Text of a charwise or linewise selection.
--- `lines`: selected text per line; `full`: the whole buffer lines they come from; `width`: terminal width.
function M.clean_lines(lines, full, charwise, width)
  lines = vim.tbl_map(function(l)
    -- Lua patterns match bytes, so the multibyte bullets can't share a [] class
    for _, bullet in ipairs({ "⏺ ", "● " }) do
      if vim.startswith(l, bullet) then
        l = "  " .. l:sub(#bullet + 1)
      end
    end
    return rtrim(l)
  end, lines)

  -- A charwise selection starts mid-line, so the first line says nothing about the shared indent
  local first = charwise and 2 or 1
  local shared = math.huge
  for i = first, #lines do
    if lines[i] ~= "" then
      shared = math.min(shared, indent(lines[i]))
    end
  end
  if shared == math.huge then
    shared = 0
  end

  local out = {}
  for i, line in ipairs(lines) do
    if i > 1 and wrapped(full[i - 1], full[i], width) then
      out[#out] = out[#out] .. " " .. ltrim(line)
    else
      table.insert(out, i < first and ltrim(line) or line:sub(shared + 1))
    end
  end
  return table.concat(out, "\n")
end

function M.yank()
  local mode = vim.fn.mode()
  local from, to = vim.fn.getpos("v"), vim.fn.getpos(".")
  local lines = vim.fn.getregion(from, to, { type = mode })

  local text
  if mode == "\22" then
    text = M.clean_block(lines)
  else
    local top = math.min(from[2], to[2])
    local full = vim.api.nvim_buf_get_lines(0, top - 1, top - 1 + #lines, true)
    -- Claude wraps at the terminal's width, which can be wider than this window (see util/term_size.lua)
    local width = require("util.term_size").width(vim.api.nvim_get_current_buf())
    text = M.clean_lines(lines, full, mode == "v", width)
  end

  vim.fn.setreg(vim.v.register, text, "v")
  vim.api.nvim_feedkeys(vim.keycode("<Esc>"), "nx", false)
end

local function map(buf)
  vim.keymap.set("x", "gy", M.yank, { buffer = buf, desc = "Yank without terminal indent and wrapping" })
end

function M.setup()
  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("term_yank", { clear = true }),
    desc = "Map gy to yank terminal text without its layout",
    callback = function(ev)
      map(ev.buf)
    end,
  })
  -- Terminals opened at startup (e.g. by cnvim) exist before this runs on VeryLazy
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      map(buf)
    end
  end
end

return M
