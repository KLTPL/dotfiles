-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Never copy when deleting or changing with 'd', 'x', 'c'
vim.keymap.set({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
vim.keymap.set({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line without yanking" })
vim.keymap.set({ "n", "v" }, "x", '"_x', { desc = "Delete character without yanking" })
vim.keymap.set({ "n", "v" }, "c", '"_c', { desc = "Change without yanking" })
vim.keymap.set({ "n", "v" }, "C", '"_C', { desc = "Change to end of line without yanking" })

-- Cut: delete and yank (non-recursive, so it reaches the built-in 'd')
vim.keymap.set({ "n", "v" }, "<leader>d", "d", { desc = "Cut (delete and yank)" })
vim.keymap.set({ "n", "v" }, "<leader>D", "D", { desc = "Cut to end of line" })

-- Paste over currently selected text without yanking it
vim.keymap.set("v", "p", "P", { desc = "Paste without replacing clipboard" })

-- Prevent the space key from moving the cursor in normal and visual mode
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Leave terminal mode with a single key instead of <C-\><C-n>
vim.keymap.set("t", "<C-q>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
-- <C-q> is a built-in alias for <C-v> (visual block); disable it so it's harmless outside terminal mode
vim.keymap.set("n", "<C-q>", "<Nop>", { desc = "Disabled (alias for <C-v>)" })

-- Move focus to a regular window (not the explorer, quickfix, a float, ...), so a terminal never replaces
-- or splits a special window. Keeps the terminal in the current tab, which matters because of scope.nvim.
local function focus_regular_window()
  local function is_float(win)
    return vim.api.nvim_win_get_config(win).relative ~= ""
  end
  -- A window showing a file or a terminal
  local function is_regular(win)
    local buftype = vim.bo[vim.api.nvim_win_get_buf(win)].buftype
    return not is_float(win) and (buftype == "" or buftype == "terminal")
  end
  -- Any other window that is not a fixed-size panel, e.g. the dashboard (sidebars like the explorer are fixed)
  local function is_replaceable(win)
    return not is_float(win) and not vim.wo[win].winfixwidth and not vim.wo[win].winfixheight
  end

  for _, is_target in ipairs({ is_regular, is_replaceable }) do
    if is_target(vim.api.nvim_get_current_win()) then
      return
    end
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
      if is_target(win) then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
  end
  -- Only special windows are open: make a new one, without the fixed size it inherits from the explorer
  vim.cmd("botright vnew")
  vim.wo.winfixwidth = false
  vim.wo.winfixheight = false
end

local function open_terminal(cmd)
  return function()
    focus_regular_window()
    vim.cmd(cmd)
  end
end

-- Open :terminal regardless of which window is focused
vim.keymap.set("n", "<leader>Tn", open_terminal("terminal"), { desc = "New terminal buffer" })
vim.keymap.set("n", "<leader>Ts", open_terminal("split | terminal"), { desc = "Terminal in split" })
vim.keymap.set("n", "<leader>Tv", open_terminal("vsplit | terminal"), { desc = "Terminal in vertical split" })
vim.keymap.set("n", "<leader>Tt", "<cmd>tabnew | terminal<cr>", { desc = "Terminal in new tab" })

-- Claude Code in a new terminal, labelled "claude" (icon in lua/config/term_icons.lua)
vim.keymap.set("n", "<leader>Tc", function()
  focus_regular_window()
  vim.cmd("terminal claude")
  vim.b.term_name = "claude"
  require("bufferline.ui").refresh()
end, { desc = "Claude Code in new terminal" })

-- Tab navigation
vim.keymap.set("n", "<leader><tab>h", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
vim.keymap.set("n", "<leader><tab>l", "<cmd>tabnext<cr>", { desc = "Next Tab" })
vim.keymap.set("n", "<leader><tab>H", "<cmd>tabfirst<cr>", { desc = "First Tab" })
vim.keymap.set("n", "<leader><tab>L", "<cmd>tablast<cr>", { desc = "Last Tab" })

vim.keymap.del("n", "<leader><tab>[")
vim.keymap.del("n", "<leader><tab>]")
vim.keymap.del("n", "<leader><tab>f")
