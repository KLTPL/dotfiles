return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- LazyVim's list without "terminal", so opening a file can replace a terminal window instead of splitting
      open_files_do_not_replace_types = { "Trouble", "trouble", "qf", "Outline" },
      filesystem = {
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
}
