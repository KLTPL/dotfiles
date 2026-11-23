return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      -- LazyVim's list without "terminal", so opening a file can replace a terminal window instead of splitting
      open_files_do_not_replace_types = { "Trouble", "trouble", "qf", "Outline" },
      window = {
        mappings = {
          ["O"] = "system_open",
        },
      },
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
      },
      filesystem = {
        group_empty_dirs = true,
        -- scan ahead so chains are collapsed before they are expanded
        scan_mode = "deep",
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = true,
        },
      },
    },
  },
}
