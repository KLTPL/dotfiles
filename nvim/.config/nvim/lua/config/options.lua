-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.opt.clipboard = "unnamedplus"

vim.opt.winbar = "%=%m %f"

vim.opt.wrap = true

-- Show "nvim: <project>" as the window title so it is easy to find in Alt+Tab
vim.opt.title = true
vim.opt.titlestring = "nvim: %{fnamemodify(getcwd(), ':t')}"

-- Make Claude Code use its classic (main-screen) renderer inside Neovim terminals,
-- so its output lands in scrollback and can be scrolled/selected in normal mode
vim.env.CLAUDE_CODE_DISABLE_ALTERNATE_SCREEN = "1"
vim.opt.scrollback = 100000

-- Neovim 0.13-dev bug: the first read of a hidden buffer's option in a session (plugins like bufferline do
-- this all the time) resizes the current terminal to the full editor width, and Claude redraws badly after
-- a resize. Doing that first read now, before any terminal exists, makes it harmless.
local scratch = vim.api.nvim_create_buf(false, true)
local _ = vim.bo[scratch].buftype
vim.api.nvim_buf_delete(scratch, { force = true })

-- Keep the markdown-preview browser tab open when switching to another buffer
vim.g.mkdp_auto_close = 0

-- Home is on ecryptfs (143-byte filename limit), too short for full-path swap names of
-- deep project files (E303); the runtime dir is a private tmpfs with the usual 255 limit
if vim.env.XDG_RUNTIME_DIR then
  vim.opt.directory = vim.env.XDG_RUNTIME_DIR .. "/nvim/swap//"
end
