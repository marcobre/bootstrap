return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- https://github.com/nvimtools/none-ls.nvim/blob/main/doc/BUILTINS.md for more
        null_ls.builtins.formatting.stylua, -- use mason to install stylua if not done yet
        null_ls.builtins.formatting.prettier, -- format javascript -use mason to install
        -- null_ls.builtins.diagnostics.eslint_d, -- diag javascript
        -- for Ruby support
        --  null_ls.builtins.diagnostics.rubocop,
        --  null_ls.builtins.formatting.rubocop, -- use mason to install rubocop
        --
        --  null_ls.builtins.completion.spell,
        --  null_ls.builtins.diagnostics.markdownlint -- for markdown linting
        --
        -- for python formatter install "black" and isort to format imports via mason
        --  null_ls.builtins.formatting.black
        --  null_ls.builtins.formatting.isort
      },
    })

    vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
  end,
}
