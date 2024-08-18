return {
  "danymat/neogen",
  opts = {
    snippet_engine = "luasnip",
  },
  languages = {
    lua = {
      template = {
        annotation_convention = "ldoc",
      },
    },
  },
  keys = {
    {
      "<leader>gd",
      function()
        require("neogen").generate()
      end,
      desc = "Annotation",
    },
  },
}
