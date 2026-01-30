-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set(
  "n",
  "gX",
  [[:exec search("- \\[ \\]", "bcn", line(".")) ? "norm ci]x" : "norm ci] "<CR>]],
  { desc = "Toggle [X]Checkbox" },
  default_opts
)
vim.keymap.set(
  "x",
  "gX",
  [[:<C-U>exec search("- \\[ \\]", "bcn", line("'<")) ? "'<,'>norm ci]x" : "'<,'>norm ci] "<CR>]],
  default_opts
)
