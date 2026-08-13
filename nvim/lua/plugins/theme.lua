return {
  "rockyzhang24/arctic.nvim",
  dependencies = { "rktjmp/lush.nvim" },
  name = "arctic",
  branch = "main",
  priority = 1000,
  config = function()
    vim.cmd("colorscheme arctic")
  end,
}

-- return {
--   "projekt0n/github-nvim-theme",
--   name = "github-theme",
--   lazy = false, -- make sure we load this during startup if it is your main colorscheme
--   priority = 1000, -- make sure to load this before all the other start plugins
--   config = function()
--     require("github-theme").setup({
--       -- ...
--     })
--
--     vim.cmd("colorscheme github_dark")
--   end,
-- }
-- return {
--   -- 1. Install the theme plugin
--   {
--     "oxfist/night-owl.nvim",
--     name = "night-owl",
--     priority = 1000,
--   },
--
--   -- 2. Tell LazyVim to use it
--   {
--     "LazyVim/LazyVim",
--     opts = {
--       colorscheme = "night-owl",
--     },
--   },
-- }
-- vimcolorschemes/vimcolorschemes
