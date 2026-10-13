return {
  "coder/claudecode.nvim",
  opts = {
    terminal = { auto_insert = false },
  },
  keys = {
    {
      "<leader>af",
      function()
        vim.cmd("ClaudeCodeFocus")
        vim.schedule(function()
          if vim.bo.buftype == "terminal" then
            vim.cmd("startinsert")
          end
        end)
      end,
      desc = "Focus Claude (insert mode)",
    },
  },
}
