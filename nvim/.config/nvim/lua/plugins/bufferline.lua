return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    -- Always show the bufferline: toggling it at 1 <-> 2 buffers resizes terminals, which garbles
    -- Claude Code's main-screen rendering (see util/claude_redraw.lua)
    opts.options.always_show_bufferline = true

    local ft_icon = opts.options.get_element_icon -- LazyVim's original

    -- label terminals with vim.b.term_name (set by :TermName) instead of "<pid>:/usr/bin/zsh"
    opts.options.name_formatter = function(buf)
      if vim.bo[buf.bufnr].buftype == "terminal" then
        return vim.b[buf.bufnr].term_name or ("term " .. buf.bufnr)
      end
    end

    -- bufferline's own terminal branch never fires, so give terminals an icon explicitly:
    -- the one registered for their :TermName label, else the shell icon
    opts.options.get_element_icon = function(icon_opts)
      if icon_opts.type == "terminal" then
        -- icon_opts carries no buffer number, only the path, so find the buffer by name
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_get_name(buf) == icon_opts.path then
            local custom = require("util.term_name").icon(vim.b[buf].term_name)
            if custom then
              return custom.icon, custom.hl
            end
            break
          end
        end
        return require("mini.icons").get("file", "zsh")
      end
      return ft_icon(icon_opts)
    end
  end,
}
