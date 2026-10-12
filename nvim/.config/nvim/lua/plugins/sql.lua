return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        -- lang.sql hardcodes --dialect=ansi, which cannot parse MySQL statements such as UPDATE ... JOIN
        sqlfluff = {
          args = { "format", "--dialect=mysql", "-" },
        },
      },
    },
  },
}
