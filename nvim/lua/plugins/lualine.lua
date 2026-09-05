return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    table.insert(opts.sections.lualine_y, 1, {
      "tabs",
      mode = 0, -- Shows tab numbers
    })
  end,
}
