-- Use snacks.nvim built-in image support (show on hover, hide on leave)
return {
  {
    "folke/snacks.nvim",
    opts = {
      image = {
        doc = {
          enabled = true,
          inline = false,
          float = true,
          max_width = 80,
          max_height = 40,
        },
      },
    },
  },
}
