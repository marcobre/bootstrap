-- Horizon Dark, to match kitty, Alacritty, tmux and the fish theme
return {
  { "akinsho/horizon.nvim", version = "*", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "horizon" },
  },
}
