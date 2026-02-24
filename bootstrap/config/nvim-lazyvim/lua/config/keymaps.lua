-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Keymap submenu for markdown is inspired by https://github.com/linkarzu/dotfiles-latest/blob/main/neovim/neobean/lua/config/keymaps.lua

local wk = require("which-key")
wk.add({
  {
    mode = { "n" },
    { "<leader>t", group = "[P]todo" },
  },
  {
    mode = { "n", "v" },
    { "<leader>m", group = "[m]arkdown" },
    --    { "<leader>mf", group = "[P]fold" },
    { "<leader>mh", group = "[P]headings increase/decrease" },
    --    { "<leader>ml", group = "[P]links" },
    --    { "<leader>ms", group = "[P]spell" },
    { "<leader>msl", group = "[P]language" },
  },
})

vim.keymap.set(
  "n",
  "<leader>mx",
  [[:exec search("- \\[ \\]", "bcn", line(".")) ? "norm ci]x" : "norm ci] "<CR>]],
  { desc = "Toggle [X]Checkbox" },
  default_opts
)
vim.keymap.set(
  "x",
  "<leader>mx",
  [[:<C-U>exec search("- \\[ \\]", "bcn", line("'<")) ? "'<,'>norm ci]x" : "'<,'>norm ci] "<CR>]],
  default_opts
)

-- Check if Marksman LSP is running, start it if not, otherwise restart lamw26wmal
vim.keymap.set("n", "<leader>mr", function()
  local is_running = false
  for _, client in ipairs(vim.lsp.get_clients()) do
    if client.name == "marksman" then
      is_running = true
      break
    end
  end
  if is_running then
    vim.cmd("LspRestart marksman")
    vim.notify("Marksman LSP restarted", vim.log.levels.INFO)
  else
    vim.cmd("LspStart marksman")
    vim.notify("Marksman LSP started", vim.log.levels.INFO)
  end
end, { desc = "[R]estart Marksman LSP" })
