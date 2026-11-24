-- Which process runs in the foreground of a terminal, used to act only while Claude Code runs
local M = {}

-- Name of the foreground process on the terminal's pty, so Claude is found also when started from a shell
function M.foreground_comm(buf)
  local pid = vim.b[buf].terminal_job_pid
  local stat = pid and io.open("/proc/" .. pid .. "/stat")
  if not stat then
    return nil
  end
  local line = stat:read("*l")
  stat:close()
  -- Fields after "(comm)": state ppid pgrp session tty_nr tpgid
  local tpgid = line:match("%) %S+ %S+ %S+ %S+ %S+ (%d+)")
  local comm = tpgid and io.open("/proc/" .. tpgid .. "/comm")
  if not comm then
    return nil
  end
  local name = comm:read("*l")
  comm:close()
  return name
end

return M
