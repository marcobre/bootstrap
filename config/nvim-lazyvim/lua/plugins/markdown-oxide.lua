return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = { enabled = false },
        markdown_oxide = {},
      },
    },
  },
  -- Ensure K calls LSP hover for markdown files (not :Man)
  -- {
  --   "neovim/nvim-lspconfig",
  --   ft = "markdown",
  --   init = function()
  --     vim.api.nvim_create_autocmd("FileType", {
  --       pattern = "markdown",
  --       callback = function()
  --         vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = true, desc = "LSP Hover" })
  --       end,
  --     })
  --   end,
  -- },
}
