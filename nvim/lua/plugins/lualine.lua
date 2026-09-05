return {
  "nvim-lualine/lualine.nvim",
  opts = function(_, opts)
    -- Ensure the layout sections exist before trying to modify them
    opts.sections = opts.sections or {}
    opts.sections.lualine_y = opts.sections.lualine_y or {}

    table.insert(opts.sections.lualine_y, 1, {
      "tabs",
      mode = 0, -- Shows tab numbers
      tabs_color = {
        active = "lualine_a_normal",
        inactive = "lualine_y_normal",
      },
      -- Use a strict table format to prevent runtime crashes
      component_separators = { left = "", right = "" },
    })
  end,
}
