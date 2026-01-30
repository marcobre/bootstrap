return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local config = require("nvim-treesitter.configs")
    config.setup({

      -- here it is about manual install vs autoinstall when required
      ensure_installed = {
      --  "lua",
      --  "html",
      --  "python",
      --  "bash",
      --  "yaml",
        "markdown",
        "markdown_inline",
      --  "vimdoc",
      --  "json",

      },
      auto_install = true,
      highlight = { enable = true },
      ignore_install = { 'org' },
      indent = { enable = true },
    })
  end,
}
