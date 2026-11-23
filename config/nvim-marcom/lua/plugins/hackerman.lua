-- Hackerman (Omarchy), same as nvim-lazyvim.
return {
  "bjarneo/hackerman.nvim",
  dependencies = { "bjarneo/aether.nvim" }, -- provides the theme engine and the lualine theme
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme("hackerman")
  end,
}
