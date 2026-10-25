-- Claude Code in a terminal buffer for the cnvim and cnv zsh functions (zsh/.zshrc).
-- The tab's cwd follows Claude's own directory, so the explorer and pickers move with it into a worktree.
local M = {}

function M.open()
  -- Args arrive one per line in $CLAUDE_TERM_ARGS, because :terminal would mangle %, # and quoting
  local args = vim.split(vim.env.CLAUDE_TERM_ARGS or "", "\n", { trimempty = true })
  vim.env.CLAUDE_TERM_ARGS = nil

  local tab = vim.api.nvim_get_current_tabpage()
  local timer = assert(vim.uv.new_timer())
  local job = vim.fn.jobstart(vim.list_extend({ "claude" }, args), {
    term = true,
    on_exit = function()
      timer:close()
    end,
  })
  local cwd_link = "/proc/" .. vim.fn.jobpid(job) .. "/cwd"
  local last = vim.uv.fs_readlink(cwd_link)

  -- Linux exposes a process's cwd as /proc/<pid>/cwd; Claude chdirs into a worktree once it is ready
  timer:start(
    1000,
    1000,
    vim.schedule_wrap(function()
      if timer:is_closing() or not vim.api.nvim_tabpage_is_valid(tab) then
        return
      end
      local dir = vim.uv.fs_readlink(cwd_link)
      if dir and dir ~= last then
        last = dir
        vim.api.nvim_win_call(vim.api.nvim_tabpage_get_win(tab), function()
          vim.cmd.tcd(vim.fn.fnameescape(dir))
        end)
      end
    end)
  )
end

return M
