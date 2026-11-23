-- Hackerman (Omarchy, https://github.com/omacom/omarchy/tree/dev/themes/hackerman),
-- to match Ghostty, kitty, Alacritty, tmux and the fish theme.
return {
  {
    "bjarneo/hackerman.nvim",
    dependencies = { "bjarneo/aether.nvim" }, -- provides the theme engine and the lualine theme
    lazy = false,
    priority = 1000,
  },
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "hackerman" },
  },
}
