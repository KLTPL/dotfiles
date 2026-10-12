-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- :TermName <label> sets the bufferline label of the current terminal (see plugins/bufferline.lua)
vim.api.nvim_create_user_command("TermName", function(cmd)
  vim.b.term_name = cmd.args
  require("bufferline.ui").refresh()
end, { nargs = 1, desc = "Set the bufferline label of the current terminal" })
