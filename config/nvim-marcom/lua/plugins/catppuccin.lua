-- Miami Wind (from the Omarchy theme by hanakin, MIT): Catppuccin Mocha grays
-- with Miami Wind accent colors, same as nvim-lazyvim.
return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    color_overrides = {
      mocha = {
        red = "#f87171",
        maroon = "#f43f5e",
        peach = "#fdba74",
        yellow = "#fef08a",
        green = "#34d399",
        teal = "#22d3ee",
        sky = "#38bdf8",
        sapphire = "#38bdf8",
        blue = "#818cf8",
        lavender = "#818cf8",
        mauve = "#ec4899",
        pink = "#f472b6",
        flamingo = "#f472b6",
        rosewater = "#f472b6",
      },
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
