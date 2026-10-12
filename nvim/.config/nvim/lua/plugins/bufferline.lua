return {
  "akinsho/bufferline.nvim",
  opts = function(_, opts)
    local ft_icon = opts.options.get_element_icon -- LazyVim's original

    -- label terminals with vim.b.term_name (set by :TermName) instead of "<pid>:/usr/bin/zsh"
    opts.options.name_formatter = function(buf)
      if vim.bo[buf.bufnr].buftype == "terminal" then
        return vim.b[buf.bufnr].term_name or ("term " .. buf.bufnr)
      end
    end

    -- bufferline's own terminal branch never fires, so give terminals the shell icon explicitly
    opts.options.get_element_icon = function(icon_opts)
      if icon_opts.type == "terminal" then
        return require("mini.icons").get("file", "zsh")
      end
      return ft_icon(icon_opts)
    end
  end,
}
