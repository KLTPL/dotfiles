return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        files = { hidden = true },
        explorer = { hidden = true, ignored = true },
        buffers = {
          -- make terminals searchable and visible by their :TermName label
          transform = function(item)
            local label = item.buf and vim.b[item.buf].term_name
            if label then
              item.term_name = label
              item.text = item.text .. " " .. label
            end
          end,
          format = function(item, picker)
            local ret = Snacks.picker.format.buffer(item, picker)
            if item.term_name then
              local custom = require("config.term_icons")[item.term_name]
              ret[#ret + 1] = { " " }
              if custom then
                ret[#ret + 1] = { custom.icon .. " ", custom.hl }
              end
              ret[#ret + 1] = { item.term_name, "SnacksPickerLabel" }
            end
            return ret
          end,
        },
      },
    },
  },
}
