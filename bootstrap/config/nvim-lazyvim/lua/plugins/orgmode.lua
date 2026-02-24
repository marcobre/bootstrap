return {
  "nvim-orgmode/orgmode",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-orgmode/telescope-orgmode.nvim",
    "nvim-orgmode/org-bullets.nvim",
    "saghen/blink.cmp",
  },
  event = "VeryLazy",
  config = function()
    require("orgmode").setup({
      org_agenda_files = "~/Syncthing/org/**/*",
      org_default_notes_file = "~/Syncthing/org/refile.org",
      org_todo_keywords = { "TODO(t)", "WAITING(w)", "|", "DONE(d)", "DELEGATED(D)" },
      org_todo_keyword_faces = {
        WAITING = ":foreground blue :weight bold",
        DELEGATED = ":background #FFFFFF :slant italic :underline on",
        TODO = ":background #000000 :foreground red", -- overrides builtin color for `TODO` keyword
      },
    })
    require("org-bullets").setup()
    require("blink.cmp").setup({
      sources = {
        per_filetype = {
          org = { "orgmode" },
        },
        providers = {
          orgmode = {
            name = "Orgmode",
            module = "orgmode.org.autocompletion.blink",
            fallbacks = { "buffer" },
          },
        },
      },
    })
    require("telescope").load_extension("orgmode")
    vim.keymap.set("n", "<leader>r", require("telescope").extensions.orgmode.refile_heading)
    vim.keymap.set("n", "<leader>fh", require("telescope").extensions.orgmode.search_headings)
    vim.keymap.set("n", "<leader>li", require("telescope").extensions.orgmode.insert_link)
  end,
}
