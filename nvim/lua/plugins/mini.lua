return {
    -- {
    --     "echasnovski/mini.jump",
    --     opts = {},
    --     keys = { "f", "F", "t", "T" },
    --     config = function(_, opts)
    --       require("mini.jump").setup(opts)
    --     end,
    --   },
      {
        "echasnovski/mini.move",
        opts = {},
            keys = { "<A-h>", "<A-l>", "<A-j>", "<A-k>" },
            config = function(_, opts)
                require("mini.move").setup(opts)
        end,
      },
}