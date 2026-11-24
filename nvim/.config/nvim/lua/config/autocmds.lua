-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Home is on ecryptfs (143-byte filename limit). Native undo files are named after the
-- file's full path, so saving deeply nested files fails with E828. For those files,
-- keep undo history in a file named by a hash of the path instead.
local NAME_MAX = 143
local hashed_undodir = vim.fn.stdpath("state") .. "/undo-hashed"

local function hashed_undofile(buf)
  local path = vim.api.nvim_buf_get_name(buf)
  if vim.bo[buf].buftype ~= "" or #path <= NAME_MAX then
    return nil
  end
  return hashed_undodir .. "/" .. vim.fn.sha256(path)
end

local long_path_undo = vim.api.nvim_create_augroup("long_path_undo", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
  group = long_path_undo,
  desc = "Read hashed undo history for paths too long for 'undodir'",
  callback = function(ev)
    local file = hashed_undofile(ev.buf)
    if file and vim.uv.fs_stat(file) then
      vim.api.nvim_buf_call(ev.buf, function()
        vim.cmd("silent rundo " .. vim.fn.fnameescape(file))
      end)
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = long_path_undo,
  desc = "Skip native undo file (E828) for paths too long for 'undodir'",
  callback = function(ev)
    if hashed_undofile(ev.buf) then
      vim.bo[ev.buf].undofile = false
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePost", {
  group = long_path_undo,
  desc = "Write hashed undo history for paths too long for 'undodir'",
  callback = function(ev)
    local file = hashed_undofile(ev.buf)
    if file then
      vim.fn.mkdir(hashed_undodir, "p")
      vim.api.nvim_buf_call(ev.buf, function()
        vim.cmd("wundo " .. vim.fn.fnameescape(file))
      end)
    end
  end,
})

-- Neovim turns 'wrap' off in terminals, so a line wider than the window (output printed before the window
-- narrowed, e.g. when the explorer opens) makes the view scroll sideways to the cursor and cut off every line.
-- With 'wrap' on, wide lines wrap and the view never shifts.
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("term_wrap", { clear = true }),
  desc = "Wrap long lines in terminal windows",
  callback = function()
    vim.wo[0][0].wrap = true
  end,
})
-- Terminals opened at startup (e.g. by cnvim) exist before this runs on VeryLazy
for _, win in ipairs(vim.api.nvim_list_wins()) do
  if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == "terminal" then
    vim.wo[win][0].wrap = true
  end
end

require("util.claude_redraw").setup()
require("util.claude_prompts").setup()
require("util.term_name").setup()
require("util.term_yank").setup()
