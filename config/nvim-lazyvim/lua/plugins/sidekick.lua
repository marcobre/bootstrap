return {
  "folke/sidekick.nvim",
  lazy = false,
  opts = {
    cli = {
      tools = {
        claude = {},
        kiro = {
          cmd = { "/Users/bretzke/.toolbox/bin/kiro-cli" },
          is_proc = "\\<kiro\\>",
        },
      },
    },
    inline = {
      enabled = true,
      auto_trigger = true,
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<c-.>",
      function()
        require("sidekick.cli").focus()
      end,
      desc = "Sidekick Focus",
      mode = { "n", "t", "i", "x" },
    },
    {
      "<leader>Aa",
      function()
        require("sidekick.cli").toggle()
      end,
      desc = "Toggle CLI",
    },
    {
      "<leader>As",
      function()
        require("sidekick.cli").select()
      end,
      desc = "Select CLI",
    },
    {
      "<leader>Ad",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach CLI Session",
    },
    {
      "<leader>At",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "n", "x" },
      desc = "Send This",
    },
    {
      "<leader>Af",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>Av",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>Ap",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Select Prompt",
    },
    {
      "<leader>Ac",
      function()
        require("sidekick.cli").toggle({ name = "claude", focus = true })
      end,
      desc = "Toggle Claude",
    },
    {
      "<leader>Ak",
      function()
        require("sidekick.cli").toggle({ name = "kiro", focus = true })
      end,
      desc = "Toggle Kiro",
    },
  },
  config = function(_, opts)
    require("sidekick").setup(opts)
  end,
}
