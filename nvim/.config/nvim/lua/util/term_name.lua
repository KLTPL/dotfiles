-- Terminal labels shown in bufferline and the buffers picker (vim.b.term_name).
-- :TermName / :Tn set them by hand; terminals running a command listed in AUTO are labelled automatically,
-- numbered ("claude 1", "claude 2", ...).
local M = {}

-- Foreground process name -> label
local AUTO = { claude = "claude" }

local DEBOUNCE_MS = 300

-- Icon for a label, ignoring a trailing number ("claude 2" -> claude's icon)
function M.icon(label)
  return label and require("config.term_icons")[label:gsub(" %d+$", "")]
end

-- First label no other terminal uses: "base 1", "base 2", ... when `numbered`, else "base", "base 2", ...
local function unique(base, buf, numbered)
  local taken = {}
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= buf and vim.bo[b].buftype == "terminal" and vim.b[b].term_name then
      taken[vim.b[b].term_name] = true
    end
  end
  local n = 1
  local label = numbered and base .. " 1" or base
  while taken[label] do
    n = n + 1
    label = base .. " " .. n
  end
  return label
end

-- Auto labels are always numbered; hand-set ones only when taken
function M.set(buf, base, auto)
  vim.b[buf].term_name = unique(base, buf, auto)
  vim.b[buf].term_name_auto = auto or nil
  require("bufferline.ui").refresh()
end

-- Label after the foreground command; never overrides a hand-set label
local function auto_name(buf)
  if not vim.api.nvim_buf_is_valid(buf) or (vim.b[buf].term_name and not vim.b[buf].term_name_auto) then
    return
  end
  local base = AUTO[require("util.foreground").foreground_comm(buf)]
  local current = vim.b[buf].term_name
  if base and not (current and current:gsub(" %d+$", "") == base) then
    M.set(buf, base, true)
  end
end

local pending = {}

function M.setup()
  for _, name in ipairs({ "TermName", "Tn" }) do
    vim.api.nvim_create_user_command(name, function(cmd)
      M.set(vim.api.nvim_get_current_buf(), cmd.args)
    end, {
      nargs = 1,
      desc = "Set the bufferline label of the current terminal",
      complete = function()
        return vim.tbl_keys(require("config.term_icons"))
      end,
    })
  end

  -- Typing a command and its first output both change the terminal while in terminal mode
  vim.api.nvim_create_autocmd("TextChangedT", {
    group = vim.api.nvim_create_augroup("term_name_auto", { clear = true }),
    desc = "Label terminals after their foreground command",
    callback = function(ev)
      if pending[ev.buf] then
        return
      end
      pending[ev.buf] = true
      vim.defer_fn(function()
        pending[ev.buf] = nil
        auto_name(ev.buf)
      end, DEBOUNCE_MS)
    end,
  })
end

return M
