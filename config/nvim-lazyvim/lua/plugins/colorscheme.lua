-- SilkCircuit Glow (https://github.com/hyperb1iss/silkcircuit, MIT), to match
-- Ghostty, kitty, Alacritty, tmux and the fish theme.
return {
  {
    "hyperb1iss/silkcircuit",
    lazy = false,
    priority = 1000,
    opts = { variant = "glow" },
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "silkcircuit" },
  },
}
