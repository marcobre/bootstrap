-- Miami Wind (from the Omarchy theme by hanakin, MIT), to match Ghostty, kitty,
-- Alacritty, tmux and the fish theme. Its grays are Catppuccin Mocha's, so
-- catppuccin (shipped with LazyVim) only needs the accent colors overridden.
return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
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
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
