return {
  "nvim-lualine/lualine.nvim",
  config = function()
  -- dependencies = { 'nvim-tree/nvim-web-devicons' }
    require('lualine').setup({
      options = {
      theme = 'dracula'
      }
    })
  end
}

