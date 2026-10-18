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

-- Keep the markdown-preview browser tab open when switching to another buffer
vim.g.mkdp_auto_close = 0
