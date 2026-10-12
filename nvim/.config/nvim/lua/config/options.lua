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
