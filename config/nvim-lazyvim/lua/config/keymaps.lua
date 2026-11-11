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
  {
    mode = { "n", "x" },
    { "<leader>A", group = "AI/Sidekick" },
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

-- Markdown Oxide: daily notes
vim.keymap.set("n", "<leader>md", function()
  vim.lsp.buf.execute_command({ command = "jump", arguments = { "today" } })
end, { desc = "Daily note [d]today" })
vim.keymap.set("n", "<leader>mD", function()
  vim.ui.input({ prompt = "Daily note (e.g. tomorrow, next monday, -3): " }, function(input)
    if input then
      vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
    end
  end)
end, { desc = "[D]aily note (prompt)" })

-- Markdown Oxide: backlinks / references
vim.keymap.set("n", "<leader>mb", function()
  vim.lsp.buf.references()
end, { desc = "[B]acklinks (references)" })

-- Markdown Oxide: restart LSP
vim.keymap.set("n", "<leader>mr", function()
  local clients = vim.lsp.get_clients({ name = "markdown_oxide" })
  if #clients > 0 then
    vim.cmd("LspRestart markdown_oxide")
    vim.notify("markdown_oxide LSP restarted", vim.log.levels.INFO)
  else
    vim.cmd("LspStart markdown_oxide")
    vim.notify("markdown_oxide LSP started", vim.log.levels.INFO)
  end
end, { desc = "[R]estart markdown_oxide LSP" })
