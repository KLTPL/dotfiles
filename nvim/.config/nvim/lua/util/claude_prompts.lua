-- [[ / ]] in terminal buffers: Neovim's defaults jump between shell prompts marked with OSC 133, which
-- Claude Code doesn't emit. While Claude is the foreground process, jump between its "❯ " prompt lines instead.
local M = {}

-- Sent prompts start with "❯ "; the input box with "❯" and a non-breaking space
local PROMPT = [[^❯ ]]
local INPUT = [[^❯\%u00a0]]

local function map(buf, lhs, flags)
  -- Neovim's buffer-local default, to fall back to while a shell is in the foreground
  local default = vim.api.nvim_buf_call(buf, function()
    return vim.fn.maparg(lhs, "n", false, true)
  end)
  local backward = flags:find("b") ~= nil
  vim.keymap.set("n", lhs, function()
    if require("util.claude_redraw").foreground_comm(buf) == "claude" then
      for _ = 1, vim.v.count1 do
        if vim.fn.search(PROMPT, flags) == 0 then
          -- Past the last sent prompt: go to the input box at the bottom
          if not backward then
            vim.fn.search(INPUT, "W")
          end
          break
        end
      end
    elseif default.callback then
      local start = vim.api.nvim_win_get_cursor(0)
      -- p10k's prompt spans two lines with the mark on the first: from the second line, step onto the
      -- first so [[ skips the current prompt instead of landing on its first line
      if backward and start[1] > 1 then
        vim.api.nvim_win_set_cursor(0, { start[1] - 1, 0 })
      end
      default.callback()
      if backward and vim.api.nvim_win_get_cursor(0)[1] == start[1] - 1 then
        vim.api.nvim_win_set_cursor(0, start)
      end
    end
  end, { buffer = buf, desc = "Jump [count] Claude or shell prompts " .. (backward and "backward" or "forward") })
end

local function map_both(buf)
  map(buf, "[[", "bW")
  map(buf, "]]", "W")
end

function M.setup()
  vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("claude_prompts", { clear = true }),
    desc = "Make [[ / ]] jump between Claude Code prompts",
    callback = function(ev)
      map_both(ev.buf)
    end,
  })
  -- Terminals opened at startup (e.g. by cnvim) exist before this runs on VeryLazy
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.bo[buf].buftype == "terminal" then
      map_both(buf)
    end
  end
end

return M
